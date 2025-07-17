//
//  File.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

extension URLRequest {
    mutating
    func add(header: HTTPHeader) {
        setValue(header.value, forHTTPHeaderField: header.key)
    }
    
    mutating
    func add(headers: [HTTPHeader]) {
        headers.forEach { header in add(header: header) }
    }
}
