//
//  Created by Vladislav Kiriukhin on 21.05.2023.
//

import Foundation
import TON

public final class ConversionRateService {
    private var rates: [Currency: Double]?

    public init() { }

    public func getRates(forceReload: Bool = false) async throws -> [Currency: Double] {
        if !forceReload, let rates {
            return rates
        }

        let currencies = Currency.allCases.map(\.rawValue).joined(separator: ",")

        guard let url = URL(string: "https://tonapi.io/v2/rates?tokens=ton&currencies=\(currencies)") else {
            return [:]
        }

        let data = try await URLSession.shared.data(for: .init(url: url)).0
        let prices = try JSONDecoder().decode(TonApiResponse.self, from: data).rates["TON"]?.prices ?? [:]

        let result = prices.reduce(into: [Currency: Double]()) { partialResult, price in
            if let currency = Currency(rawValue: price.key) {
                partialResult[currency] = price.value
            }
        }

        self.rates = result
        return result
    }
}

private struct TonApiResponse: Decodable {
    let rates: [String: Rates]

    struct Rates: Decodable {
        let prices: [String: Double]
    }
}
