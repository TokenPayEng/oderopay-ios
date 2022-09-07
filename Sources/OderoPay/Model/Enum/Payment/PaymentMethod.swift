//
//  PaymentMethod.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum PaymentMethod: String, Codable {
    case CARD_PAYMENT = "CARD_PAYMENT"
    case MULTI_CARD_PAYMENT = "MULTICARD_PAYMENT"
}
