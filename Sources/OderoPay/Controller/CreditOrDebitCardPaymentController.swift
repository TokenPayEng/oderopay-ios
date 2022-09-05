//
//  CreditOrDebitCardPaymentController.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

struct CreditOrDebitCardPaymentController: FormProtocol {
    
    var cardController: CardController
    
    var isformEnabled: Bool = false
    
    var isCardValid: Bool {
        return cardController.isCardValid()
    }
    
    var hasInstallment: Bool = false
    
    var height: CGFloat {
        isformEnabled ? isCardValid ? 300 : 220 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    mutating func enableForm(_ value: Bool) {
        self.isformEnabled = value
    }
}
