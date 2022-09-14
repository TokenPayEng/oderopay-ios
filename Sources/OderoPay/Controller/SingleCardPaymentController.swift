//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 14.09.22.
//

import Foundation
import UIKit

class SingleCardPaymentController: FormProtocol {
    
    var cardController: CreditOrDebitCardPaymentController
    
    var isformEnabled: Bool = false
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }

        return cardController.height
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ cardController: CreditOrDebitCardPaymentController) {
        self.cardController = cardController
        self.cardController.isformEnabled = true
    }
}
