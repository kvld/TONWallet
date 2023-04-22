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

        // Contract
        guard let boc = Data(hexString: "B5EE9C72410215010002F5000114FF00F4A413F4BCF2C80B010201200203020148040504F8F28308D71820D31FD31FD31F02F823BBF263ED44D0D31FD31FD3FFF404D15143BAF2A15151BAF2A205F901541064F910F2A3F80024A4C8CB1F5240CB1F5230CBFF5210F400C9ED54F80F01D30721C0009F6C519320D74A96D307D402FB00E830E021C001E30021C002E30001C0039130E30D03A4C8CB1F12CB1FCBFF1112131403EED001D0D3030171B0915BE021D749C120915BE001D31F218210706C7567BD228210626C6E63BDB022821064737472BDB0925F03E002FA403020FA4401C8CA07CBFFC9D0ED44D0810140D721F404305C810108F40A6FA131B3925F05E004D33FC8258210706C7567BA9131E30D248210626C6E63BAE30004060708020120090A005001FA00F404308210706C7567831EB17080185005CB0527CF165003FA02F40012CB69CB1F5210CB3F0052F8276F228210626C6E63831EB17080185005CB0527CF1624FA0214CB6A13CB1F5230CB3F01FA02F4000092821064737472BA8E3504810108F45930ED44D0810140D720C801CF16F400C9ED54821064737472831EB17080185004CB0558CF1622FA0212CB6ACB1FCB3F9410345F04E2C98040FB000201200B0C0059BD242B6F6A2684080A06B90FA0218470D4080847A4937D29910CE6903E9FF9837812801B7810148987159F31840201580D0E0011B8C97ED44D0D70B1F8003DB29DFB513420405035C87D010C00B23281F2FFF274006040423D029BE84C600201200F100019ADCE76A26840206B90EB85FFC00019AF1DF6A26840106B90EB858FC0006ED207FA00D4D422F90005C8CA0715CBFFC9D077748018C8CB05CB0222CF165005FA0214CB6B12CCCCC971FB00C84014810108F451F2A702006C810108D718C8542025810108F451F2A782106E6F746570748018C8CB05CB025004CF16821005F5E100FA0213CB6A12CB1FC971FB00020072810108D718305202810108F459F2A7F82582106473747270748018C8CB05CB025005CF16821005F5E100FA0214CB6A13CB1F12CB3FC973FB00000AF400C9ED5446A9F34F") else {
            return
        }

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
