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
    var pointsController: PointsController?
    
    var isformEnabled: Bool = false
    
    var installmentsEnabled: Bool = false
    
    var hasInstallment: Bool {
        cardController.hasInstallments()
    }
    var installmentItem: RetrieveInstallmentDataResult? {
        hasInstallment ? cardController.retrieveInstallment() : nil
    }
    
    var isCardValid: Bool {
        cardController.isCardValid()
    }
    
    var hasPayByPoints: Bool {
        cardController.isExpireValid() && cardController.isCardValid()
    }
    
    var isPaymentComplete: Bool = false
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        
        var calculatingHeight: CGFloat = 220
        
        if hasInstallment {
            let count = cardController.retrieveInstallment()!.getInstallmentItems().count
            calculatingHeight += CGFloat(51 + (60 * count))
        }
        
        if isCardValid {
            calculatingHeight += 80
        }
        
        if pointsController != nil {
            if hasPayByPoints {
                calculatingHeight += 67
            }
            
            if pointsController!.getContentState() {
                calculatingHeight += 326
            }
        }
        
        return calculatingHeight
    }
    
    init(_ cardController: CardController, with pointsController: PointsController? = nil) {
        self.cardController = cardController
        self.pointsController = pointsController
    }
}
