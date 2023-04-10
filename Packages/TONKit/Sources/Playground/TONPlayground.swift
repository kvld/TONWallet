//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TONClient
import TONSchema

@main
final class TONPlayground {
    static func main() async throws -> Void {
        let url = URL(string: "https://ton.org/testnet-global.config.json")!
        let configData = try await URLSession.shared.data(from: url).0

        let client = TONClient()

        // 1.
        let fn = Init(
            options: .init(
                config: .init(
                    config: String(data: configData, encoding: .utf8)!,
                    blockchainName: "",
                    useCallbacksForNetwork: false,
                    ignoreCache: false
                ),
                keystoreType: .keyStoreTypeInMemory(.init())
            )
        )

        let options = try await client.execute(fn)

        // 2.
        let password = Data([0x00, 0x01, 0x02])
        let createNewKey = CreateNewKey(
            localPassword: password,
            mnemonicPassword: password,
            randomExtraSeed: .init()
        )

        let key = try await client.execute(createNewKey)

        print("Public Key:", key.publicKey)
        print("Secret:", key.secret)

        // 3.
        let walletInitialID = options.configInfo.defaultWalletId

        let getAccount = GetAccountAddress(
            initialAccountState: .walletV3InitialAccountState(
                .init(publicKey: key.publicKey, walletId: walletInitialID)
            ),
            revision: 0,
            workchainId: 0
        )

        let result = try await client.execute(getAccount)
        print("Account address:", result.accountAddress)

        try await Task.sleep(nanoseconds: 600 * 1_000_000_000)
    }
}
