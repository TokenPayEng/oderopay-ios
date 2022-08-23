//
//  PaymentItem.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public struct PaymentItem: Codable {
    
    // mandatory
    private var name: String
    private var price: Double
    
    // optional
    private var externalId: String?
    private var subMerchantId: Int?
    private var subMerchantPrice: Int?
    
    public init(
        named name: String,
        for price: Int,
        externalId: String? = nil,
        subMerchantId: Int? = nil,
        subMerchantPrice: Int? = nil) {
            self.name = name
            self.price = price
            self.externalId = externalId
            self.subMerchantId = subMerchantId
            self.subMerchantPrice = subMerchantPrice
    }
}
