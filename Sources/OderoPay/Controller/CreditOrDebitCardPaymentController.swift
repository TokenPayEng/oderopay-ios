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
        isformEnabled ? 300 : 0
    }
}
