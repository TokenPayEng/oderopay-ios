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
    
    enum Key: CodingKey {
        case rawValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .TRY:
            try container.encode("TRY", forKey: .rawValue)
        case .AZN:
            try container.encode("AZN", forKey: .rawValue)
        case .USD:
            try container.encode("USD", forKey: .rawValue)
        case .EURO:
            try  container.encode("EURO", forKey: .rawValue)
        }
    }
}
