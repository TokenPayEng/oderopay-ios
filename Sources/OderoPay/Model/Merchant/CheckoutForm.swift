//
//  CheckoutForm.swift
//  
//
//  Created by Imran Hajiyev on 10.08.22.
//

import Foundation

public class CheckoutForm {

    // mandatory
    private var price: Int
    private var currency: Currency
    private var orderNumber: String
    
    // optional
    private var email: String?
    
    static private var isReady: Bool = false
    
    convenience init() {
        self.init(orderNumber: "unknown", for: 0, in: .USD)
        
        CheckoutForm.isReady = false
    }
    
    public init(orderNumber: String, for price: Int, in currency: Currency) {
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
        
        CheckoutForm.isReady = true
    }
    
    public init(orderNumber: String, for price: Int, in currency: Currency, from email: String) {
        self.email = email
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
        
        CheckoutForm.isReady = true
    }
    
    public func isReady() -> Bool {
        CheckoutForm.isReady
    }
    
    public func setCheckoutForm(to form: CheckoutForm) {
        self.orderNumber = form.orderNumber
        self.price = form.price
        self.currency = form.currency
        
        guard let email = form.email else {return}
        self.email = email
    }
    
}
