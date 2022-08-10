//
//  PaymentResult.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

struct PaymentResult {
    
    var id: Int
    var conversationId: String
    var createdDate: Date
    var price: Int
    var paidPrice: Int
    var walletPrice: Int
    var currency: Currency
    var installment: Int
    var paymentType: PaymentType
    var paymentMethod: PaymentMethod
    var paymentPhase: PaymentPhase
    var paymentStatus: PaymentStatus
    var is3DS: Bool
    var paidWithStoredCard: Bool
    var lastFourDigits: String
}
