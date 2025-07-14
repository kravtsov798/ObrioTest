//
//  Endpoint.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

protocol Endpoint {
    var method: HTTPMethod { get }
    var headers: [HTTPHeader] { get }
    
    var bodyModel: Codable? { get }
    var body: Data? { get }
    
    var url: URL? { get }
    var path: String { get }
    var queries: [URLQueryItem] { get }
    
    func createURLRequest() throws -> URLRequest
}

extension Endpoint {
    var queries: [URLQueryItem] { [] }
    
    var bodyModel: Codable? { nil }
    
    var body: Data? {
        guard let bodyModel else { return nil }
        return try? JSONEncoder().encode(bodyModel)
    }
    
    func createURLRequest() throws -> URLRequest {
        guard let url else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.add(headers: headers)
        urlRequest.httpBody = body
        return urlRequest
    }
}
