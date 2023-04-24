//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import Foundation
import Combine

struct NoValuesEmmittedError: Error { }

extension AnyPublisher {
    var async: Output {
        get async throws {
            try await withCheckedThrowingContinuation { continuation in
                var cancellable: AnyCancellable?
                var noValuesEmmitted = true

                cancellable = first()
                    .sink { result in
                        switch result {
                        case .finished:
                            if noValuesEmmitted {
                                continuation.resume(throwing: NoValuesEmmittedError())
                            }

                        case let .failure(error):
                            continuation.resume(throwing: error)
                        }

                        cancellable?.cancel()
                    } receiveValue: { value in
                        noValuesEmmitted = false
                        
                        continuation.resume(with: .success(value))
                    }
            }
        }
    }
}
