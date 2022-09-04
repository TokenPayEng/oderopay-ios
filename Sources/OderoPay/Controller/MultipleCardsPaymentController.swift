//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

struct MultipleCardsPaymentController: FormProtocol {
    var isformEnabled: Bool = false
    var isCardValid: Bool = false
    var hasInstallment: Bool = false
    
    var height: CGFloat {
        isformEnabled ? isCardValid ? 670 : 590 : 0
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    mutating func enableForm(_ value: Bool) {
        self.isformEnabled = value
    }
    
    mutating func validCard(_ value: Bool) {
        self.isCardValid = value
    }
}
