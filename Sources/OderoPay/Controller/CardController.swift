//
//  CardController.swift
//  
//
//  Created by Imran Hajiyev on 03.09.22.
//

import Foundation

struct CardController {
    private var isValidCard: Bool = false
    private var cardAssociation: CardAssociation = .UNDEFINED
    private var cardIinRangeString: String = String()
    private var currentCardNumber: String = String()
    private var updatedCardNumber: String = String()
    
    private var expireMonth: String = String()
    private var expireYear: String = String()
    private var currentExpireDate: String = String()
    private var updatedExpireDate: String = String()
    let month = Calendar.current.component(.month, from: Date())
    let year = Calendar.current.component(.year, from: Date())
    
    mutating func setCurrentCardNumber(to number: String) {
        self.currentCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    mutating func setUpdatedCardNumber(to number: String) {
        self.updatedCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func getUpdatedCardNumber() -> String {
        self.updatedCardNumber
    }
    
    mutating func setCurrentExpireDate(to date: String) {
        self.currentExpireDate = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    mutating func setUpdatedExpireDate(to date: String) {
        self.updatedExpireDate = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func getUpdatedExpireDate() -> String {
        self.updatedExpireDate
    }
    
    mutating func setExpireMonth(to month: String) {
        self.expireMonth = month
    }
    
    mutating func setExpireYear(to year: String) {
        self.expireYear = year
    }
    
    func getExpireMonth() -> String {
        self.expireMonth
    }
    
    func getExpireYear() -> String {
        self.expireYear
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
    
    mutating func isCardNumberValid(_ number: String) -> Bool {
        
        switch cardAssociation {
        case .VISA:
            print("in here")
            if Visa.lengthRanges.contains(number.count) {
                print("visa to luhn")
                isValidCard = luhnAlgorithm(number)
            } else {
                isValidCard = false
            }
        case .VISA_ELECTRON:
            if VisaElectron.lengthRanges.contains(number.count) {
                isValidCard = luhnAlgorithm(number)
            } else {
                isValidCard = false
            }
        case .MASTER_CARD:
            if MasterCard.lengthRanges.contains(number.count) {
                isValidCard = luhnAlgorithm(number)
            } else {
                isValidCard = false
            }
        case .MAESTRO:
            if Maestro.lengthRanges.contains(number.count) {
                isValidCard = luhnAlgorithm(number)
            } else {
                isValidCard = false
            }
        case .AMEX:
            if AmericanExpress.lengthRanges.contains(number.count) {
                isValidCard = luhnAlgorithm(number)
            } else {
                isValidCard = false
            }
        case .UNDEFINED:
            isValidCard = false
        }
        
        return isValidCard
    }
    
    func isCardValid() -> Bool {
        isValidCard
    }
    
    func luhnAlgorithm(_ number: String) -> Bool {
        var luhmSum: Int = 0
        let numberReversed = number.reversed().map { String($0) }
        
        for tuple in numberReversed.enumerated() {
            if let digit = Int(tuple.element) {
                let oddIndex = tuple.offset % 2 == 1
                
                switch(oddIndex, digit) {
                case (true, 9):
                    luhmSum += 9
                case (true, 0...8):
                    luhmSum += (digit * 2) % 9
                default:
                    luhmSum += digit
                }
            } else {
                return false
            }
        }
        
        print(luhmSum)
        
        return luhmSum % 10 == 0
    }
}
