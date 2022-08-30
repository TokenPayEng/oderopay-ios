//
//  Currency.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum Currency: String, Codable {
    case TRY = "₺"
    case AZN = "₼"
    case USD = "$"
    case EURO = "€"
}

extension Currency {
    enum CodingKeys: String, CodingKey {
        case TRY = "TRY"
        case AZN = "AZN"
        case USD = "USD"
        case EURO = "EURO"
    }
}
