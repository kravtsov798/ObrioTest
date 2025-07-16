//
//  ResponseModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

struct ResponseModel<T: Decodable>: Decodable {
    var data: T
    var statusCode: String?
}
