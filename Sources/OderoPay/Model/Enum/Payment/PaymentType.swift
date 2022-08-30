//
//  PaymentType.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum PaymentType: String, Codable {
    case PRODUCT = "PRODUCT"
    case LISTING = "LISTING"
    case SUBSCRIPTION = "SUBSCRIPTION"
}
