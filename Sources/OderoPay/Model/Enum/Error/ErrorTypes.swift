//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 08.09.22.
//

import Foundation

enum ErrorTypes: String {
    case NETWORK = "networkError"
    case INTERNAL = "internalError"
    case SERVER = "serverError"
    case MISSING_DATA = "missingError"
    case UNKNOWN = "unknownError"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
