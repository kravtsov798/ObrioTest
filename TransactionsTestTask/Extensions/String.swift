//
//  String.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import Foundation

extension String {
    var double: Double? {
        Double(self.replacingOccurrences(of: ",", with: "."))
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localizedFormat(_ args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
}
