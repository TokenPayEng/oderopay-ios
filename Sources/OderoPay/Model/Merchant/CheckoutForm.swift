//
//  CheckoutForm.swift
//  
//
//  Created by Imran Hajiyev on 10.08.22.
//

import Foundation

public class CheckoutForm {

    // mandatory
    private var price: Double
    private var currency: Currency
    private var orderNumber: String
    
    // optional
    private var email: String?
    
    static private var isReady: Bool = false
    
    convenience init() {
        self.init(orderNumber: "unknown", for: 0, in: .USD)
    }
    
    public init(orderNumber: String, for price: Double, in currency: Currency) {
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
    }
    
    public init(orderNumber: String, for price: Double, in currency: Currency, from email: String) {
        self.email = email
        self.orderNumber = orderNumber
        self.price = price
        self.currency = currency
    }
    
    public func isReady() -> Bool {
        CheckoutForm.isReady
    }
    
    public func setCheckoutForm(to form: CheckoutForm) {
        self.orderNumber = form.orderNumber
        self.price = form.price
        self.currency = form.currency
        
        CheckoutForm.isReady = true
        
        guard let email = form.email else {return}
        self.email = email
    }
    
    public func getCheckoutPrice() -> String {
        String(format: "%.2f", price) + " \(currency.rawValue)"
    }
    
    public func getCheckoutCurrency() -> String {
        currency.rawValue
    }
    
}
