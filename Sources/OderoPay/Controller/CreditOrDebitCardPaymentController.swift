//
//  CreditOrDebitCardPaymentController.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class CreditOrDebitCardPaymentController: FormProtocol {
    
    var cardController: CardController
    
    var isformEnabled: Bool = false
    var hasInstallment: Bool {
        cardController.hasInstallments()
    }
    
    var isCardValid: Bool {
        cardController.isCardValid()
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        
        var calculatingHeight: CGFloat = 220
        
        if hasInstallment {
            calculatingHeight += 95
        }
        
        if isCardValid {
            calculatingHeight += 80
        }
        
        return calculatingHeight
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ cardController: CardController) {
        self.cardController = cardController
    }
}
