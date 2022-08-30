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
    private var subMerchantPrice: Double?
    
    // TODO: CHANGE BACK TO NIL
    public init(
        named name: String,
        for price: Double,
        externalId: String? = nil,
        subMerchantId: Int? = nil,
        subMerchantPrice: Double? = nil) {
            self.name = name
            self.price = price
            self.externalId = externalId
            self.subMerchantId = subMerchantId ?? 0
            self.subMerchantPrice = subMerchantPrice ?? price
    }
}
