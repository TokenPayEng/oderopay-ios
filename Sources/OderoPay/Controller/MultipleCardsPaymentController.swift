//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class MultipleCardsPaymentController: FormProtocol {
    
    var firstCardController: CardController
    var secondCardController: CardController
    
    var isformEnabled: Bool = false
    var hasInstallmentFirstCard: Bool {
        firstCardController.hasInstallments()
    }
    
    var installmentItemsFirstCard: [RetrieveInstallmentItem] {
        hasInstallmentFirstCard ? firstCardController.retrieveInstallments() : []
    }
    
    var hasInstallmentSecondCard: Bool {
        secondCardController.hasInstallments()
    }
    
    var installmentItemsSecondCard: [RetrieveInstallmentItem] {
        hasInstallmentSecondCard ? secondCardController.retrieveInstallments() : []
    }
    
    var isFirstCardValid: Bool {
        firstCardController.isCardValid()
    }
    var isSecondCardValid: Bool {
        secondCardController.isCardValid()
    }
    
//    var firstVerticalDividerHeight: CGFloat {
//        var calculatingHeight: CGFloat = 220
//        
//        if hasInstallment {
//            let count = cardController.retrieveInstallments().first!.getInstallmentItems().count
//            calculatingHeight += CGFloat(51 + (60 * count))
//        }
//        
//        if isCardValid {
//            calculatingHeight += 80
//        }
//        
//        return calculatingHeight
//    }
    
    var height: CGFloat {
        isformEnabled ? isFirstCardValid ? isSecondCardValid ? 943 : 943 : 943 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ firstCardController: CardController, and secondCardController: CardController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
    }
}
