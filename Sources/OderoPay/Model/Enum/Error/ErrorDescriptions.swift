//
//  ErrorDescriptions.swift
//  
//
//  Created by Imran Hajiyev on 08.09.22.
//

import Foundation

enum ErrorDescriptions: String {
    case LATER = "laterErrorDescription"
    case NOW = "errorDescription"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, bundle: .module,comment: "")
    }
    
    static func getLocalized(_ choice: ErrorDescriptions) -> String {
        return choice.localizedString()
    }
}
