//
//  PaymentPhase.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum PaymentPhase: String, Codable {
    case AUTH = "AUTH"
    case PRE_AUTH = "PRE_AUTH"
    case POST_AUTH = "POST_AUTH"
}
