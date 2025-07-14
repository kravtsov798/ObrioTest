//
//  UITextField.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

extension UITextField {
    func setPlaceholder(_ text: String, color: UIColor, font: UIFont? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        if let font = font {
            attributes[.font] = font
        }
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
