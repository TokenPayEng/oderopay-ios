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
    var hasInstallment: Bool = false
    
    var isCardValid: Bool {
        cardController.isCardValid()
    }
    
    var height: CGFloat {
        isformEnabled ? isCardValid ? 300 : 220 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ cardController: CardController) {
        self.cardController = cardController
    }
    
    func printAll() {
        print(isCardValid)
        print(height)
    }
}
