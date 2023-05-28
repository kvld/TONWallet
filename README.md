# TONWallet 

Submission for [wallet-contest](https://github.com/ton-community/wallet-contest) by TON.
It's based on [tonlib](https://github.com/ton-blockchain/ton) (with patch for support v4 wallets) and uses [code-generated TL schema in Swift](https://github.com/kvld/TONWallet/blob/master/Packages/TONKit/Sources/Schema/TONSchemaGenerated.swift) for communication through JSON API.

## Build steps
1. Clone this git repo: `git clone https://github.com/kvld/TONWallet.git`
2. Open in Xcode `TONWallet/TONWallet.xcworkspace`
3. Wait for project be ready
4. *(optional if you want to build on real device not simulator)* Update project signing and bundle identifier `Project > Signing & Capabilities`
5. Build and run

## Additional info
These steps are not necessary to build the project. 
To rebuild `rlottie` framework run:
```bash
cd Tools/Frameworks/RLottie
./build.sh
```

To rebuild `tonlibjson` run:
```bash
# build openssl first...
cd Tools/Frameworks/OpenSSL
./build.sh

# ...then run tonlibjson
cd ../Tonlib
sh build.sh ../OpenSSL/bin 
```

To generate schema based on \*.tl file, run [TONSchemaGenerator](https://github.com/kvld/TONWallet/blob/master/Packages/TONKit/Sources/SchemaGenerator/TONSchemaGenerator.swift) from Xcode or with `swift run` command.
