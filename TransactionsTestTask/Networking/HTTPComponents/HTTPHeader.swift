//
//  HTTPHeader.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

struct HTTPHeader {
    var key: String
    var value: String?
    
    public init(key: String, value: String?) {
        self.key = key
        self.value = value
    }
}
