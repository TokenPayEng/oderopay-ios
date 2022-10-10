//
//  StoredCard.swift
//  
//
//  Created by Imran Hajiyev on 10.10.22.
//

import Foundation

struct StoredCard: Codable {
    private var cardNumber: String
    private var expireMonth: Months
    private var expireYear: String
    private var cardHolderName: String
    private var binNumber: String
    private var lastFourDigits: String
    private var cardToken: String
    private var cardBrand: String
    private var cardType: CardType
}
