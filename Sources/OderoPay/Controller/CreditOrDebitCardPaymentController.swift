//
//  CreditOrDebitCardPaymentController.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

struct CreditOrDebitCardPaymentController: FormProtocol {
    var isformEnabled: Bool = false
    var isCardValid: Bool = false
    var hasInstallment: Bool = false
    
    var height: CGFloat {
        isformEnabled ? isCardValid ? 300 : 220 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
}
