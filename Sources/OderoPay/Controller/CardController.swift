//
//  CardController.swift
//  
//
//  Created by Imran Hajiyev on 03.09.22.
//

import Foundation

struct CardController {
    private var cardAssociation: CardAssociation = .UNDEFINED
    private var cardIinRangeString: String = String()
    
    private var expireMonth: String = String()
    private var expireYear: String = String()
    
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
    mutating func checkForCardAssociation() -> CardAssociation {
        // initial check for association
        if cardAssociation == .UNDEFINED {
            cardAssociation = CardInformationView.cardRepository.lookUpCardAssociation(Int(updatedCardNumber) ?? 0)
            cardIinRangeString = updatedCardNumber
        }
        
        // setting iin range as undefined if pattern changes
        cardAssociation = updatedCardNumber.count == 0 ? .UNDEFINED : cardAssociation
        cardAssociation = cardIinRangeString.count > updatedCardNumber.count && cardAssociation == .VISA_ELECTRON ? .VISA : cardIinRangeString.count > updatedCardNumber.count ? .UNDEFINED : cardAssociation
        
        return cardAssociation
    }
    
    mutating func checkIfAssociationIsVisaElectron() -> Bool {
        if CardInformationView.cardRepository.isVisaElectron(Int(updatedCardNumber) ?? 0) {
            cardAssociation = .VISA_ELECTRON
            cardIinRangeString = updatedCardNumber
            
            return true
        } else {
            cardIinRangeString = String(Visa.iinRanges.first!)
            
            return false
        }
    }
}
