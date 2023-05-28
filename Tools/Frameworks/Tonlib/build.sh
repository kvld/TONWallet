#!/bin/bash

set -eo pipefail

framework_name=TONLibJSON

current_path=$(pwd)
openssl_path=$(cd $(dirname "$1");pwd)/$(basename "$1")

rm -rf ios-cmake
git clone https://github.com/leetal/ios-cmake
toolchain_path="$(pwd)/ios-cmake/ios.toolchain.cmake"

rm -rf ton
git clone --recurse-submodules https://github.com/ton-blockchain/ton
cd ton

git apply ../wallet_v4.patch

ton_path=$(pwd)

# Prepare

rm -rf build-native
mkdir -p build-native
cd build-native

cross_compiling_platform_sdk=$openssl_path/Mac

echo "Using sdk ${cross_compiling_platform_sdk}"

openssl_crypto_library="${cross_compiling_platform_sdk}/lib/libcrypto.a"
options="$options -DOPENSSL_FOUND=1"
options="$options -DOPENSSL_CRYPTO_LIBRARY=${openssl_crypto_library}"
options="$options -DOPENSSL_INCLUDE_DIR=${cross_compiling_platform_sdk}/include"
options="$options -DCMAKE_BUILD_TYPE=Release"
options="$options -DTON_ONLY_TONLIB=ON"
options="$options -DTON_ARCH="

cmake $options $ton_path
cmake --build . --target prepare_cross_compiling
cd ..

rm -rf build
mkdir -p build
cd build

echo "Tonlib path = ${ton_path}"
echo "OpenSSL path = ${openssl_path}"
echo "Toolchain path = ${toolchain_path}"

# Build

ios_deployment_target="14.0"

platforms="ios_arm64 ios-simulator_arm64 ios-simulator_x86-64"

for platform in $platforms;
do
    if [[ $platform == ios_* ]]; then
        lib_platform="iOS"
        target="OS64"
        archs="arm64"
    fi

    if [[ $platform == ios-simulator* ]]; then
        lib_platform="iOS-simulator"

        if [[ $platform == *arm64 ]]; then
            target="SIMULATORARM64"
            archs="arm64"
        fi

        if [[ $platform == *x86-64 ]]; then
            target="SIMULATOR64"
            archs="x86_64"
        fi
    fi

    echo "Build for ${lib_platform} / ${target}"

    openssl_platform_path="${openssl_path}/${lib_platform}"
    openssl_crypto_library="${openssl_platform_path}/lib/libcrypto.a"

    build_directory="build-${platform}"
    install_directory="install-${platform}"

    options="$options -DOPENSSL_FOUND=1"
    options="$options -DOPENSSL_CRYPTO_LIBRARY=${openssl_crypto_library}"
    options="$options -DOPENSSL_INCLUDE_DIR=${openssl_platform_path}/include"
    options="$options -DCMAKE_BUILD_TYPE=Release"
    options="$options -DTON_ONLY_TONLIB=ON"
    options="$options -DPLATFORM=${target}"
    options="$options -DCMAKE_TOOLCHAIN_FILE=${toolchain_path}"
    options="$options -DCMAKE_INSTALL_PREFIX=../${install_directory}"
    options="$options -DARCHS=${archs}"
    options="$options -DCMAKE_MACOSX_BUNDLE=NO"
    options="$options -DTON_ARCH="
    options="$options -DDEPLOYMENT_TARGET=${ios_deployment_target}"

    rm -rf $build_directory
    rm -rf $install_directory
    
    mkdir -p $build_directory
    mkdir -p $install_directory

    cd $build_directory

    cmake $ton_path $options
    cmake --build . --config Release
    cmake --install . --config Release

    cd ..
done

# Frameworks

dylib_name=libtonlibjson.dylib

rm -rf frameworks
mkdir -p frameworks

for platform in $platforms;
do
    install_directory="install-${platform}"
    cd $install_directory

    lipo -create "lib/${dylib_name}" -output "${framework_name}"
    install_name_tool -id @rpath/$framework_name.framework/$framework_name $framework_name

    mv "${framework_name}" "../frameworks/${framework_name}_${platform}"

    cd ..
done

cd frameworks

simulator_path=simulator
device_path=device

rm -rf $simulator_path
mkdir -p $simulator_path

rm -rf $device_path
mkdir -p $device_path

simulator_framework_path=$simulator_path/$framework_name.framework
mkdir -p $simulator_framework_path

device_framework_path=$device_path/$framework_name.framework
mkdir -p $device_framework_path

simulator_platforms="ios-simulator_arm64 ios-simulator_x86-64"
device_platforms="ios_arm64"

for platform in $simulator_platforms;
do
    simulator_paths="$simulator_paths ${framework_name}_${platform}"
done

for platform in $device_platforms;
do
    device_paths="$device_paths ${framework_name}_${platform}"
done

lipo -create $simulator_paths -output $simulator_framework_path/$framework_name
lipo -create $device_paths -output $device_framework_path/$framework_name

# Copy headers

headers="tonlib_client_json tonlibjson_export"

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
    mkdir -p $simulator_framework_path/Headers/tonlib
    mkdir -p $device_framework_path/Headers/tonlib

    cp "../install-ios_arm64/include/tonlib/${header}.h" $simulator_framework_path/Headers/tonlib/
    cp "../install-ios_arm64/include/tonlib/${header}.h" $device_framework_path/Headers/tonlib/

    # strip "tonlib" in include paths
    gsed -i 's/tonlib\///g' $simulator_framework_path/Headers/tonlib/$header.h
    gsed -i 's/tonlib\///g' $device_framework_path/Headers/tonlib/$header.h
done

cp $current_path/Templates/Info.plist $device_framework_path/
cp $current_path/Templates/Info.plist $simulator_framework_path/

cp $current_path/Templates/module.modulemap $device_framework_path/Modules/
cp $current_path/Templates/module.modulemap $simulator_framework_path/Modules/

xcodebuild -create-xcframework \
    -framework $simulator_framework_path \
    -framework $device_framework_path \
    -output $framework_name.xcframework

cp -R $framework_name.xcframework ../../../$framework_name.xcframework

cd ../../..
rm -rf ton
rm -rf ios-cmake
