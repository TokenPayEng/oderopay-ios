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
    var hasInstallment: Bool = false
    
    var isFirstCardValid: Bool {
        firstCardController.isCardValid()
    }
    var isSecondCardValid: Bool {
        secondCardController.isCardValid()
    }
    
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
