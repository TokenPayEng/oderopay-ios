//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class MultipleCardsPaymentController: FormProtocol {
    
    var firstCardController: CreditOrDebitCardPaymentController
    var secondCardController: CreditOrDebitCardPaymentController
    
    var isformEnabled: Bool = false
    
//    var installmentsEnabledFirstCard: Bool = false
//    var hasInstallmentFirstCard: Bool {
//        firstCardController.hasInstallments()
//    }
//
//    var installmentItemsFirstCard: [RetrieveInstallmentItem] {
//        hasInstallmentFirstCard ? firstCardController.retrieveInstallments() : []
//    }
//
//    var installmentsEnabledSecondCard: Bool = false
//    var hasInstallmentSecondCard: Bool {
//        secondCardController.hasInstallments()
//    }
//
//    var installmentItemsSecondCard: [RetrieveInstallmentItem] {
//        hasInstallmentSecondCard ? secondCardController.retrieveInstallments() : []
//    }
//
//    var isFirstCardValid: Bool {
//        firstCardController.isCardValid()
//    }
//    var isSecondCardValid: Bool {
//        secondCardController.isCardValid()
//    }
    
    var firstVerticalDividerHeight: CGFloat {
        firstCardController.height
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        
        return firstCardController.height + secondCardController.height + 151
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ firstCardController: CreditOrDebitCardPaymentController, and secondCardController: CreditOrDebitCardPaymentController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
    }
}
