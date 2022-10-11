//
//  CardController.swift
//  
//
//  Created by Imran Hajiyev on 03.09.22.
//

import Foundation

class CardController {
    var controllerType: CardControllers = .NOT_DEFINED
    
    private var isValidCard: Bool = false
    private var isValidExpire: Bool = false
    private var isValidCVC: Bool = false
    private var isValidName: Bool = false
    
    private var installmentFound: Bool = false
    
    private var cardNumber: String {
        updatedCardNumber
    }
    
    private var expireDate: String = String()
    private var cvc: String = String()
    private var cardHolder: String = String()
    
    private var installmentItem: RetrieveInstallmentDataResult? = nil
    private var installmentChoice: Int = 1
    private var installmentPrice: Double = 0
    private var block3DSChoice: Bool = false
    private var force3DSChoice: Bool = false
    private var saveCardChoice: Bool = false
    
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
    
    func setCardHolder(to name: String) {
        self.cardHolder = name
    }
    
    func setCVC(to cvc: String) {
        self.cvc = cvc
    }
    
    func setExpireDate(to expireDate: String) {
        self.expireDate = expireDate
    }
    
    func retrieveCardNumber() -> String {
        self.cardNumber
    }
    
    func retrieveExpireDate() -> (Months ,String)? {
        guard let month = Months(rawValue: String(self.expireDate.prefix(2))) else { return nil }
        return (month, "20\(self.expireDate.suffix(2))")
    }
    
    func retrieveCVC() -> String {
        self.cvc
    }
    
    func retrieveCardHolder() -> String {
        self.cardHolder
    }
    
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
            self.force3DSChoice = false
            self.block3DSChoice = false
            self.installmentChoice = 1
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
            }
        }
        
        if currentCardNumber.count == 5 && updatedCardNumber.count == 6 {
            
            print("\nStarting process of installments retrieval\n")
            
            // if single card payment retrieve installments from checkout, else from card price labels
            var priceToCheck: Double
            
            switch controllerType {
            case .NOT_DEFINED:
                print("\n‼️ WARNING: Card controller does not appear to have a type. (SINGLE, MULTI-1, MULTI-2) ‼️\n")
                priceToCheck = 0
            case .SINGLE_CREDIT:
                priceToCheck = OderoPay.getCheckoutForm().getCheckoutPriceRaw()
            case .MULTI_FIRST:
                priceToCheck = OderoPay.getPricesForMultipleCardsPayment().0
            case .MULTI_SECOND:
                priceToCheck = OderoPay.getPricesForMultipleCardsPayment().1
            }
            
            do {
                let retrieveInstallmentsResponse = try await OderoPay.retrieveInstallments(
                    for: updatedCardNumber,
                    withPrice: priceToCheck,
                    in: OderoPay.getCheckoutForm().getCheckoutCurrencyRaw()
                )
                
                if retrieveInstallmentsResponse.hasErrors() != nil {
                    print("installments retrieval returned with errors --- FAIL ❌")
                    print("Error code: \(String(describing: retrieveInstallmentsResponse.hasErrors()?.getErrorCode()))")
                    print("Error description: \(String(describing: retrieveInstallmentsResponse.hasErrors()?.getErrorDescription()))")
                    
                    self.block3DSChoice = false
                    self.installmentFound = false
                    self.force3DSChoice = false
                    self.installmentChoice = 1
                    
                    return
                }
                
                guard let resultFromServer = retrieveInstallmentsResponse.hasData() else {
                    print("Error occured ---- FAIL ❌")
                    print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")
                    
                    self.block3DSChoice = false
                    self.installmentFound = false
                    self.force3DSChoice = false
                    self.installmentChoice = 1
                    
                    return
                }
            
                print("retrieving installments...")
                self.installmentItem = resultFromServer
                print("items retrieved ---- SUCCESS ✅")
                print("installments retrieved for card with bin number: \(updatedCardNumber) and initial price: \(priceToCheck) ---- SUCCESS ✅\n")
                
                self.installmentFound = self.installmentItem != nil
                self.force3DSChoice = self.installmentItem!.getForce3ds()
                self.block3DSChoice = self.installmentItem!.getForce3ds()
                self.installmentChoice = 1

                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
                }
                return
            } catch {
                print("network error occured ---- FAIL ❌")
                print("HINT: \(error)")
                self.installmentFound = false
                self.force3DSChoice = false
                self.force3DSChoice = false
                self.installmentChoice = 1
                
                return
            }
        }
    }
    
    func hasInstallments() -> Bool {
        installmentFound
    }
    
    func retrieveInstallment() -> RetrieveInstallmentDataResult? {
        installmentItem
    }
    
    func toggleForce3DSChoiceOption() {
        force3DSChoice.toggle()
    }
    
    func toggleSaveCardChoiceOption() {
        saveCardChoice.toggle()
    }
    
    func retrieveBlock3DSChoiceOption() -> Bool {
        block3DSChoice
    }
    
    func retrieveForce3DSChoiceOption() -> Bool {
        force3DSChoice
    }
    
    func retrieveSaveCardChoiceOption() -> Bool {
        saveCardChoice
    }
    
    func setInstallmentChoice(_ index: Int, is value: Double) {
        installmentChoice = index
        print(value)
        installmentPrice = value
    }
    
    func retrieveInstallmentChoice() -> Int {
        self.installmentChoice
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
    
    func isExpireDateValid(_ date: String) -> Bool {
        if date.count == 5 && date.contains("/") {
            isValidExpire = true
        } else {
            isValidExpire = false
        }
        
        return isValidExpire
    }
    
    func isCVCCodeValid(_ code: String) -> Bool {
        isValidCVC = code.count == 3
        return isValidCVC
    }
    
    func isNameHolderValid(_ name: String) -> Bool {
        if name.range(of: "^[A-Z][a-z]{2,}(?: [A-Z][a-z]*)*$", options: .regularExpression) != nil {
            isValidName = true
        } else {
            isValidName = false
        }
        
        return isValidName
    }
    
    func isCardValid() -> Bool {
        isValidCard
    }
    
    func isExpireValid() -> Bool {
        isValidExpire
    }
    
    func isCVCValid() -> Bool {
        isValidCVC
    }
    
    func isNameValid() -> Bool {
        isValidName
    }
    
    func isCardInfoValid() -> Bool {        
        return isValidCard && isValidExpire && isValidCVC && isValidName
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
