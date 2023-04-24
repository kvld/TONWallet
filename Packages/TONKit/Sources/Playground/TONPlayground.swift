//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TONClient
import TONSchema
import BOC
import Mnemonic

@main
final class TONPlayground {
    static func main() async throws -> Void {
        // Request
        let url = URL(string: "https://ton.org/testnet-global.config.json")!
        let configData = try await URLSession.shared.data(from: url).0

        let client = TONClient()

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

        let walletInitialID = options.configInfo.defaultWalletId

        print("Public Key:", key.publicKey)
        print("Secret:", key.secret)
        print("Wallet initial ID", walletInitialID)

        let publicKeyData = "PubRNSNKA91N7Q4KU-k96SrQPiflmEr5m1g1M839_CQvBENJ".data(using: .utf8)!
        let address = "EQDeeUtefYu_OeZcTSl2zakJ_wMXLNSWSld84fFeM2u-kUJd"

        let fakeKey = InputKey.inputKeyFake(.init())

        let request1 = RawGetAccountState(accountAddress: .init(accountAddress: address))

        let request2 = RawGetTransactions(
            privateKey: fakeKey,
            accountAddress: .init(accountAddress: address),
            fromTransactionId: .init(
                lt: .init(10654424000003),
                hash: Data(hexString: "420b77317931b353f2641031cf02062e32ba800ceb4c6d1aa4cd32c24a854f8a")!
            )
        )

        do {
            let transactions = try await client.execute(request2)
            print(transactions)
        } catch {
            print(error)
        }

        try await Task.sleep(nanoseconds: 60 * 1_000_000_000)
    }

}
