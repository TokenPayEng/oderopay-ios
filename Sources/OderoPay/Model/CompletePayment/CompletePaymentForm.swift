//
//  CompletePaymentForm.swift
//  
//
//  Created by Imran Hajiyev on 06.09.22.
//

import Foundation

public class CompletePaymentForm: Codable {
    // mandatory
    private var paymentType: PaymentMethod
    private var cardPrice: Double
    private var installment: Installment
    private var card: Card
    
    // optional
    private var walletPrice: Double?
    private var totalPointPrice: Double?
    private var loyaltyPointPrice: Double?
    
    convenience init() {
        self.init(
            paymentType: .CARD_PAYMENT,
            cardPrice: 0,
            installment: .single,
            card: Card()
        )
    }
    
    /// public initializer for the checkout form class.
    public init(paymentType: PaymentMethod,
                cardPrice: Double,
                walletPrice: Double? = nil ,
                totalPointPrice: Double? = nil,
                loyaltyPointPrice: Double? = nil,
                installment: Installment,
                card: Card) {
        self.paymentType = paymentType
        self.cardPrice = cardPrice
        self.walletPrice = walletPrice
        self.totalPointPrice = totalPointPrice
        self.loyaltyPointPrice = loyaltyPointPrice
        self.installment = installment
        self.card = card
    }
}
