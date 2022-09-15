//
//  Card.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public class Card: Codable {
    private var cardNumber: String
    private var expireMonth: Months
    private var expireYear: String
    private var cvc: String
    private var cardHolderName: String
    
    // optional
    private var storeCardAfterSuccessPayment: Bool?
    private var cardAlias: String?
    private var cardUserKey: String?
    private var cardToken: String?
    
    convenience init() {
        self.init(
            number: "0000000000000000",
            expiringAt: .december,
            "2000",
            withCode: "000",
            belongsTo: "John Doe"
        )
    }
    
    /// public initializer for the checkout form class.
    public init(number cardNumber: String,
                expiringAt expireMonth: Months,
                _ expireYear: String,
                withCode cvc: String,
                belongsTo cardHolderName: String,
                aliasedAs cardAlias: String? = nil,
                shouldBeStored storeCardAfterSuccessPayment: Bool? = nil,
                userKey cardUserKey: String? = nil,
                token cardToken: String? = nil) {
        self.cardNumber = cardNumber
        self.expireMonth = expireMonth
        self.expireYear = expireYear
        self.cvc = cvc
        self.cardHolderName = cardHolderName
        self.storeCardAfterSuccessPayment = storeCardAfterSuccessPayment
        self.cardAlias = cardAlias
        self.cardUserKey = cardUserKey
        self.cardToken = cardToken
    }
}
