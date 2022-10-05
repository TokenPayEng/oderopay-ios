//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 05.10.22.
//

import Foundation
import UIKit

class TextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
