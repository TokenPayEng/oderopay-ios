//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class MultipleCardsPaymentController: FormProtocol {
    var isformEnabled: Bool = false
    var isCardValid: Bool = false
    var hasInstallment: Bool = false
    
    var height: CGFloat {
        isformEnabled ? isCardValid ? 670 : 590 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    func enableForm(_ value: Bool) {
        self.isformEnabled = value
    }
    
    func validCard(_ value: Bool) {
        self.isCardValid = value
    }
}
