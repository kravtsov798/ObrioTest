//
//  NetworkError.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

enum NetworkError: Error {
    case decodingFailed(description: String)
    case invalidResponse
    case invalidURL
    
    case clientError(code: Int)
    case serverError(code: Int)
    case unknownError(code: Int)
}
