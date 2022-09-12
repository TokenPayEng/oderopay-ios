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
    
    var firstVerticalDividerHeight: CGFloat {
        firstCardController.height + 60
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        print(firstCardController.height)
        print(secondCardController.height)
        return firstCardController.height + secondCardController.height + 151 + 60
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ firstCardController: CreditOrDebitCardPaymentController, and secondCardController: CreditOrDebitCardPaymentController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
        self.firstCardController.isformEnabled = true
        self.secondCardController.isformEnabled = true
    }
}
