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
    
    var installmentsEnabledFirstCard: Bool = false
    var hasInstallmentFirstCard: Bool {
        firstCardController.hasInstallments()
    }
    
    var installmentItemsFirstCard: [RetrieveInstallmentItem] {
        hasInstallmentFirstCard ? firstCardController.retrieveInstallments() : []
    }
    
    var installmentsEnabledSecondCard: Bool = false
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
    
    var firstVerticalDividerHeight: CGFloat {
        var calculatingHeight: CGFloat = 246
        
        if hasInstallmentFirstCard {
            let count = firstCardController.retrieveInstallments().first!.getInstallmentItems().count
            calculatingHeight += CGFloat(51 + (70 * count))
        }
        
        if isFirstCardValid {
            calculatingHeight += 80
        }
        
        return calculatingHeight
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        
        var calculatingHeight: CGFloat = 561
        
        if hasInstallmentFirstCard {
            let count = firstCardController.retrieveInstallments().first!.getInstallmentItems().count
            calculatingHeight += CGFloat(51 + (70 * count))
        }
        
        if hasInstallmentSecondCard {
            let count = secondCardController.retrieveInstallments().first!.getInstallmentItems().count
            calculatingHeight += CGFloat(51 + (60 * count))
        }
        
        if isFirstCardValid {
            calculatingHeight += 80
        }
        
        if isSecondCardValid {
            calculatingHeight += 80
        }
        
        return calculatingHeight
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ firstCardController: CardController, and secondCardController: CardController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
    }
}
