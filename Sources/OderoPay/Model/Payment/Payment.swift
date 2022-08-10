//
//  Payment.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

struct Payment {
    
    // mandatory
    private var price: Int
    private var paidPrice: Int
    private var installment: Int
    private var currency: Currency
    private var paymentType: PaymentType
    private var paymentMethod: PaymentMethod
    private var conversationId: String
    private var card: Card
    private var items: [PaymentItem]
    
    // optional
    private var walletPrice: Int
    private var buyerId: Int
    private var posAlias: String
    
    // 3ds
    private var callbackURL: String
}
