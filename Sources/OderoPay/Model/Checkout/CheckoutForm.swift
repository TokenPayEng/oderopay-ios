//
//  CheckoutForm.swift
//  
//
//  Created by Imran Hajiyev on 10.08.22.
//

import Foundation

public class CheckoutForm: Codable {

    // mandatory
    private var price: Double
    private var paidPrice: Double
    private var currency: Currency
    private var paymentGroup: PaymentType
    private var items: [PaymentItem]
    private var callbackUrl: String = String()
    
    // optional
    private var conversationId: String?
    private var walletPrice: Double?
    private var buyerId: Double?
    private var cardUserKey: String?
    private var email: String?
    
    static private var isReady: Bool = false
    
    convenience init() {
        self.init(ofProducts: [],
                  ofType: .PRODUCT,
                  priceToPayInitial: 0,
                  priceToPayAfterDiscounts: 0,
                  in: .USD)
    }
    
    /// public initializer for the checkout form class.
    public init(orderNumber: String? = nil,
                ofProducts: [PaymentItem],
                ofType paymentType: PaymentType,
                priceToPayInitial: Double,
                priceToPayAfterDiscounts: Double,
                in currency: Currency,
                withExistingWalletBalance: Double? = nil,
                fromBuyerWithId: Double? = nil,
                withUserEmail: String? = nil,
                withUserCardKey: String? = nil) {
        self.conversationId = orderNumber
        self.price = priceToPayInitial
        self.paidPrice = priceToPayAfterDiscounts
        self.walletPrice = withExistingWalletBalance
        self.buyerId = fromBuyerWithId
        self.cardUserKey = withUserCardKey
        self.currency = currency
        self.paymentGroup = paymentType
        self.items = ofProducts
        self.email = withUserEmail
    }
    
    /// Returns whether the checkout form was initialized and ready to be used. Of type Bool.
    public func isReady() -> Bool {
        CheckoutForm.isReady
    }
    
    /// Created checkout form object passed to the main checkout form.
    public func setCheckoutForm(to form: CheckoutForm) {
        self.conversationId = form.conversationId
        self.price = form.price
        self.paidPrice = form.paidPrice
        self.walletPrice = form.walletPrice
        self.buyerId = form.buyerId
        self.cardUserKey = form.cardUserKey
        self.currency = form.currency
        self.paymentGroup = form.paymentGroup
        self.items = form.items
        self.email = form.email
        
        CheckoutForm.isReady = true
    }
    
    /// Function returns checkout currency. Of type Currency Enum.
    public func getCheckoutCurrencyRaw() -> Currency {
        currency
    }
    
    /// - Returns: Function returns checkout price with discounts applied without the currency value. Of type Double.
    public func getCheckoutPriceRaw() -> Double {
        paidPrice
    }
    
    /// Function returns checkout price with discounts applied together with currency value. Of type String.
    public func getCheckoutPrice() -> String {
        String(format: "%.2f", paidPrice) + " \(currency.currencySign)"
    }
    
    /// Function returns checkout currency value. Of type Sstring.
    public func getCheckoutCurrency() -> String {
        currency.rawValue
    }
    
}
