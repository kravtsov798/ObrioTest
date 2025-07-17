//
//  NetworkService.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

class NetworkService {
    private let session: URLSession
     
    init(session: URLSession? = nil) {
        if let session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 5
            self.session = URLSession(configuration: config)
        }
    }
    
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        try checkResponseStatusCode(response)
        return try decode(from: data)
    }
    
    private func checkResponseStatusCode(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        guard (200...299).contains(statusCode) else {
            throw switch statusCode {
            case 400...499: NetworkError.clientError(code: statusCode)
            case 500...599: NetworkError.serverError(code: statusCode)
            default: NetworkError.unknownError(code: statusCode)
            }
        }
    }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(description: error.localizedDescription)
        }
    }
}

extension NetworkService {
    func request<T: Decodable>(with endpoint: Endpoint) async throws -> T {
        let urlRequest = try endpoint.createURLRequest()
        let responceModel: ResponseModel<T> = try await request(urlRequest)
        return responceModel.data
    }
}
