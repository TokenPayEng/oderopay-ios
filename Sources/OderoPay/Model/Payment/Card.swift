//
//  Card.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

struct Card {
    
    var cardNumber: String
    var expireMonth: String
    var expireYear: String
    var cvc: String
    var cardHolderName: String
    var storeCardAfterSuccessPayment: Bool
    var cardAlias: String
    
    // for card storage
    var cardUserKey: String
    var cardToken: String
}
