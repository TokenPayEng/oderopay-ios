//
//  CheckoutForm.swift
//  
//
//  Created by Imran Hajiyev on 10.08.22.
//

import Foundation

public class CheckoutForm {

    // mandatory
    var price: Int
    var currency: Currency
    var orderNumber: String
    
    // optional
    var email: String?
    
    static private var isReady: Bool = false
    
    convenience init() {
        self.init(orderNumber: "unknown", for: 0, in: .USD)
        
        CheckoutForm.isReady = false
    }
    
    init(orderNumber: String, for price: Int, in currency: Currency) {
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
        
        CheckoutForm.isReady = true
    }
    
    init(orderNumber: String, for price: Int, in currency: Currency, from email: String) {
        self.email = email
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
        
        CheckoutForm.isReady = true
    }
    
    func isReady() -> Bool {
        CheckoutForm.isReady
    }
    
}
