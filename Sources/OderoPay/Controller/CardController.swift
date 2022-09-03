//
//  CardController.swift
//  
//
//  Created by Imran Hajiyev on 03.09.22.
//

import Foundation

struct CardController {
    private var cardAssociation: CardAssociation = .UNDEFINED
    private var cardNumberPattern: String = "#### ##"
    
    private var expireMonth: String = String()
    private var expireYear: String = String()
    private var expireDatePattern: String = "##/##"
    
    private let month = Calendar.current.component(.month, from: Date())
    private let year = Calendar.current.component(.year, from: Date())
    
    private var currentCardNumber: String = String()
    private var updatedCardNumber: String = String()
    
    mutating func setCurrentCardNumber(to number: String) {
        self.currentCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    mutating func setUpdatedCardNumber(to number: String) {
        self.updatedCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    // installment
    func checkForAvailableInstallment() {
        if currentCardNumber.count == 5 && updatedCardNumber.count == 6 {
            print("fired installment")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        }
    }
    
    // card association
}
