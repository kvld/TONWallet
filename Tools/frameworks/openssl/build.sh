#!/bin/bash

set -eo pipefail

# Build OpenSSL

rm -rf Build-OpenSSL-cURL
git clone https://github.com/jasonacox/Build-OpenSSL-cURL

cd Build-OpenSSL-cURL

./build.sh -o 1.1.1t -s 10.0 -d

rm -rf ../bin
mkdir ../bin

cd openssl
cp -R Mac ../../bin/
cp -R iOS ../../bin/
cp -R iOS-simulator ../../bin

cd ../../bin

libs="libcrypto libssl"
for lib in $libs;
do 
    # iOS
    lipo -remove armv7 "iOS/lib/${lib}.a" -o "iOS/lib/${lib}.a"
    lipo -remove armv7s "iOS/lib/${lib}.a" -o "iOS/lib/${lib}.a"

    # iOS simulator
    lipo -remove i386 "iOS-simulator/lib/${lib}.a" -o "iOS-simulator/lib/${lib}.a"
done

rm Build-OpenSSL-cURL