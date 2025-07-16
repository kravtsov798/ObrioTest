//
//  AlertBuilding.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import UIKit

protocol AlertBuilder {
    @discardableResult
    func addTitle(_ title: String) -> Self
    
    @discardableResult
    func addMessage(_ message: String) -> Self
    
    @discardableResult
    func setStyle(_ style: UIAlertController.Style) -> Self
    
    @discardableResult
    func addAction(title: String,
                   actionStyle: UIAlertAction.Style,
                   handler: @escaping ((UIAlertAction) -> Void)) -> Self
    
    @discardableResult
    func reset() -> Self
    
    func build() -> UIAlertController
}

final class AlertBuilderImpl: AlertBuilder {
    private var title: String?
    private var message: String?
    private var style: UIAlertController.Style = .alert
    private var actions: [UIAlertAction] = []
    
    @discardableResult
    func addTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    @discardableResult
    func addMessage(_ message: String) -> Self {
        self.message = message
        return self
    }
    
    @discardableResult
    func setStyle(_ style: UIAlertController.Style) -> Self {
        self.style = style
        return self
    }
    
    @discardableResult
    func addAction(title: String,
                   actionStyle: UIAlertAction.Style,
                   handler: @escaping ((UIAlertAction) -> Void)) -> Self {
        let action = UIAlertAction(title: title,
                                   style: actionStyle,
                                   handler: handler)
        actions.append(action)
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        reset()
        return alert
    }
    
    @discardableResult
    func reset() -> Self {
        title = nil
        message = nil
        style = .alert
        actions.removeAll()
        return self
    }
}
