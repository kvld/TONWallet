//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TonLibJSON
import TONSchema

public final class TONClient {
    private let client: UnsafeMutableRawPointer
    private let timeout: TimeInterval

    private var executingFunctions: [UUID: (Result<Decoder, Swift.Error>) -> Void] = [:]

    private lazy var executingFunctionsQueue = DispatchQueue(
        label: "TONClientExecutingFunctionsQueue",
        qos: .userInitiated
    )

    private lazy var receiveQueue = DispatchQueue(label: "TONClientReceiveQueue", qos: .userInitiated)

    public init(timeout: TimeInterval = 10.0) {
        self.timeout = timeout
        self.client = tonlib_client_json_create()

        #if DEBUG
            tonlib_client_set_verbosity_level(.max)
        #endif

        receiveQueue.async { [weak self] in
            self?.receiveEventsFromTONLib()
        }
    }

    private func receiveEventsFromTONLib() {
        while true {
            let result = tonlib_client_json_receive(client, timeout)

            // TODO: errors
            guard let result, let jsonData = String(cString: result).data(using: .utf8) else {
                continue
            }

            guard let response = try? JSONDecoder().decode(TONClientResponse.self, from: jsonData),
                  let uuid = response.uuid else {
                continue
            }

            executingFunctionsQueue.sync {
                let completion = self.executingFunctions.removeValue(forKey: uuid)

                if let error = response.error {
                    completion?(.failure(error))
                } else {
                    completion?(.success(response.decoder))
                }
            }
        }
    }

    deinit {
        tonlib_client_json_destroy(client)
    }
}

extension TONClient {
    public func execute<Function: TLFunction>(
        _ function: Function
    ) async throws -> Function.ReturnType {
        let uuid = UUID()
        return try await self.execute(function, uuid: uuid)
    }

    private func execute<Function: TLFunction>(
        _ function: Function,
        uuid: UUID
    ) async throws -> Function.ReturnType {
        let request = TONClientRequest(uuid: uuid, function: function)
        let json = try JSONEncoder().encode(request)

        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }

            self.executingFunctionsQueue.sync {
                self.executingFunctions[uuid] = { result in
                    do {
                        switch result {
                        case let .success(decoder):
                            let returnObject = try Function.ReturnType(from: decoder)
                            continuation.resume(returning: returnObject)
                        case let .failure(error):
                            throw error
                        }
                    } catch let error as DecodingError {
                        continuation.resume(
                            throwing: ParsingResponseError(expectedType: "\(Function.ReturnType.self)", error: error)
                        )
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }

            String(data: json, encoding: .utf8)?.withCString { pointer in
                tonlib_client_json_send(client, pointer)
            }
        }
    }
}
