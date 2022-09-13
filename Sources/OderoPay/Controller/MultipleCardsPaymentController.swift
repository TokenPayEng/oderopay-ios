//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class MultipleCardsPaymentController: FormProtocol {
    
    private let totalPrice: Double = OderoPay.getCheckoutForm().getCheckoutPriceRaw()
    private var _firstAmount: Double = 0
    var firstAmount: Double {
        get {
            return _firstAmount
        }
        set {
            if newValue < totalPrice {
                _firstAmount = newValue
            } else {
                print("Cannot set to more than total price")
            }
        }
    }
    var secondAmount: Double {
        totalPrice - firstAmount
    }
    var firstCardController: CreditOrDebitCardPaymentController
    var secondCardController: CreditOrDebitCardPaymentController
    
    var isformEnabled: Bool = false
    
    var firstVerticalDividerHeight: CGFloat {
        firstCardController.height + 75
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }

        return firstCardController.height + secondCardController.height + (self.secondCardController.isformEnabled ? 181 : 166)
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ firstCardController: CreditOrDebitCardPaymentController, and secondCardController: CreditOrDebitCardPaymentController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
        
        self.firstCardController.isformEnabled = true
        self.secondCardController.isformEnabled = false
        
        self.firstAmount = 0        
    }
    
    func getTotalPrice() -> Double {
        totalPrice
    }
}
