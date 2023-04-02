#!/bin/bash

set -eo pipefail

brew install gnu-sed

threads=$(sysctl hw.ncpu | awk '{print $2}')

current_path=$(pwd)

rm -rf rlottie
git clone https://github.com/TelegramMessenger/rlottie

cp CMakeLists.txt rlottie/CMakeLists.txt

xcode_path=`xcode-select -p`

simulator_runtime_path=${xcode_path}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
device_runtime_path=${xcode_path}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

targets="ios-arm64 ios_simulator-x86_64 ios_simulator-arm64"

install_path=${current_path}/artifacts

rm -rf ${install_path}
mkdir -p ${install_path}

# Build separate dylibs

for target in $targets;
do
    cd ${current_path}/rlottie

    rm -rf build
    mkdir -p build
    cd build

    arch=""
    sdk=""

    if [[ $target == ios-* ]]; then
        sdk=${device_runtime_path}
    else
        sdk=${simulator_runtime_path}
    fi

    if [[ $target == *-arm64 ]]; then
        arch="arm64"
    fi
    
    if [[ $target == *-x86_64 ]]; then
        arch="x86_64"
    fi

    echo "Building for ${sdk} ${arch}... (${target})"

    target_path=${install_path}/${target}
    
    cmake .. -DCMAKE_SYSTEM_NAME=iOS \
            "-DCMAKE_OSX_ARCHITECTURES=${arch}" \
            -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
            -DCMAKE_OSX_SYSROOT=${sdk} \
            -DLIB_INSTALL_DIR=${target_path}

    make rlottie -j "${threads}" install || exit
done

# Create fat library

rm -rf frameworks
mkdir -p frameworks

dylib_name=rlottie.dylib
framework_name=RLottie

rm -rf $install_path/ios_simulator
mkdir -p $install_path/ios_simulator

lipo -create $install_path/ios_simulator-x86_64/$dylib_name $install_path/ios_simulator-arm64/$dylib_name -o $install_path/ios_simulator/$dylib_name

# Create frameworks

simulator_path=${current_path}/frameworks/simulator
device_path=${current_path}/frameworks/device

rm -rf $simulator_path
mkdir -p $simulator_path

rm -rf $device_path
mkdir -p $device_path

simulator_framework_path=$simulator_path/$framework_name.framework
rm -rf $simulator_framework_path
mkdir -p $simulator_framework_path

device_framework_path=$device_path/$framework_name.framework
rm -rf $device_framework_path
mkdir -p $device_framework_path

lipo -create ${install_path}/ios_simulator/${dylib_name} -output $simulator_framework_path/$framework_name
lipo -create ${install_path}/ios-arm64/${dylib_name} -output $device_framework_path/$framework_name

install_name_tool -id @rpath/$framework_name.framework/$framework_name $simulator_framework_path/$framework_name
install_name_tool -id @rpath/$framework_name.framework/$framework_name $device_framework_path/$framework_name

# Copy headers and module map

headers="rlottie_capi rlottiecommon"

rm -rf $simulator_framework_path/Headers
mkdir -p $simulator_framework_path/Headers

rm -rf $device_framework_path/Headers
mkdir -p $device_framework_path/Headers

rm -rf $simulator_framework_path/Modules
mkdir -p $simulator_framework_path/Modules

rm -rf $device_framework_path/Modules
mkdir -p $device_framework_path/Modules

for header in $headers;
do
    cp "${install_path}/ios-arm64/include/${header}.h" $simulator_framework_path/Headers/
    cp "${install_path}/ios-arm64/include/${header}.h" $device_framework_path/Headers/

    gsed -i 's/<rlottiecommon\.h>/\"rlottiecommon\.h\"/g' $simulator_framework_path/Headers/$header.h
    gsed -i 's/<rlottiecommon\.h>/\"rlottiecommon\.h\"/g' $device_framework_path/Headers/$header.h
done

cp $current_path/templates/Info.plist $device_framework_path/
cp $current_path/templates/Info.plist $simulator_framework_path/

cp $current_path/templates/module.modulemap $device_framework_path/Modules/
cp $current_path/templates/module.modulemap $simulator_framework_path/Modules/

# Create xcframework

cd $current_path/frameworks

xcframework_output=$current_path/$framework_name.xcframework
rm -rf $xcframework_output

xcodebuild -create-xcframework \
    -framework device/$framework_name.framework \
    -framework simulator/$framework_name.framework \
    -output $xcframework_output

cd ..
rm -rf frameworks
rm -rf artifacts
rm -rf rlottie