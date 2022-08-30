//
//  Currency.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum Currency: String, Codable {
    case TRY = "TRY"
    case AZN = "AZN"
    case USD = "USD"
    case EURO = "EURO"
}

extension Currency {
    var currencySign: String {
        switch self {
        case .TRY:
            return "₺"
        case .AZN:
            return "₼"
        case .USD:
            return "$"
        case .EURO:
            return "€"
        }
    }
}
