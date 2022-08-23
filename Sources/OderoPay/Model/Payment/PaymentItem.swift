//
//  PaymentItem.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public struct PaymentItem: Codable {
    
    private var externalId: String
    private var name: String
    private var price: Int
    private var subMerchantId: Int
    private var subMerchantPrice: Int
}
