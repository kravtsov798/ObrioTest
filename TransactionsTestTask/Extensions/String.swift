//
//  String.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import Foundation

extension String {
    var double: Double? { Double(self.replacingOccurrences(of: ",", with: ".")) }
}
