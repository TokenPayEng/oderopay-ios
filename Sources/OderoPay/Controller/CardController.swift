//
//  CardController.swift
//  
//
//  Created by Imran Hajiyev on 03.09.22.
//

import Foundation

class CardController {
    private var isValidCard: Bool = false
    private var installmentFound: Bool = false
    private var installmentItems: [RetrieveInstallmentItem] = []
    private var force3DSChoice: Bool = false
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
    
    func setCurrentCardNumber(to number: String) {
        self.currentCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func setUpdatedCardNumber(to number: String) {
        self.updatedCardNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func getUpdatedCardNumber() -> String {
        self.updatedCardNumber
    }
    
    func setCurrentExpireDate(to date: String) {
        self.currentExpireDate = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func setUpdatedExpireDate(to date: String) {
        self.updatedExpireDate = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func getUpdatedExpireDate() -> String {
        self.updatedExpireDate
    }
    
    func setExpireMonth(to month: String) {
        self.expireMonth = month
    }
    
    func setExpireYear(to year: String) {
        self.expireYear = year
    }
    
    func getExpireMonth() -> String {
        self.expireMonth
    }
    
    func getExpireYear() -> String {
        self.expireYear
    }
    
    // installment
    func checkForAvailableInstallment() async {
        
        if currentCardNumber.count == 6 && updatedCardNumber.count == 5 {
            self.installmentFound = false
            NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
        }
        
        if currentCardNumber.count == 5 && updatedCardNumber.count == 6 {
            
            print("\nStarting process of installments retrieval\n")
            
            do {
                let retrieveInstallmentsResponse = try await OderoPay.retrieveInstallments(
                    for: updatedCardNumber,
                    withPrice: OderoPay.getCheckoutForm().getCheckoutPriceRaw(),
                    // in: OderoPay.getCheckoutForm().getCheckoutCurrencyRaw()
                    in: .TRY
                )
                
                if retrieveInstallmentsResponse.hasErrors() != nil {
                    print("installments retrieval returned with errors --- FAIL ❌")
                    print("Error code: \(String(describing: retrieveInstallmentsResponse.hasErrors()?.getErrorCode()))")
                    print("Error description: \(String(describing: retrieveInstallmentsResponse.hasErrors()?.getErrorDescription()))")
                    self.installmentFound = false
                    return
                }
                
                guard let resultFromServer = retrieveInstallmentsResponse.hasData() else {
                    print("Error occured ---- FAIL ❌")
                    print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")
                    self.installmentFound = false
                    return
                }
            
                print("retrieving installments...")
                self.installmentItems = resultFromServer.getItems()
                print("items retrieved ---- SUCCESS ✅")
                print(self.installmentItems)
                print("installments retrieved for card with bin number: \(updatedCardNumber) ---- SUCCESS ✅\n")
                
                self.installmentFound = !self.installmentItems.isEmpty
                self.force3DSChoice = self.installmentItems.first?.getForce3ds() ?? false

                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
                }
                return
            } catch {
                print("network error occured ---- FAIL ❌")
                print("HINT: \(error)")
                self.installmentFound = false
                return
            }
        }
    }
    
    func hasInstallments() -> Bool {
        installmentFound
    }
    
    func retrieveInstallments() -> [RetrieveInstallmentItem] {
        installmentItems
    }
    
    func retrieveForce3DSChoiceOption() -> Bool {
        force3DSChoice
    }
    
    // card association
    func checkForCardAssociation() -> CardAssociation {
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
    
    func checkIfAssociationIsVisaElectron() -> Bool {
        if CardInformationView.cardRepository.isVisaElectron(Int(updatedCardNumber) ?? 0) {
            cardAssociation = .VISA_ELECTRON
            cardIinRangeString = updatedCardNumber
            
            return true
        } else {
            cardIinRangeString = String(Visa.iinRanges.first!)
            
            return false
        }
    }
    
    func isCardNumberValid(_ number: String) -> Bool {
        
        switch cardAssociation {
        case .VISA:
            if Visa.lengthRanges.contains(number.count) {
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
        
        NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
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
        
        return luhmSum % 10 == 0
    }
}
