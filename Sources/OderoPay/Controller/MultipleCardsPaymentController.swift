//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation
import UIKit

class MultipleCardsPaymentController: FormProtocol {
    
    var firstCardController: CreditOrDebitCardPaymentController
    var secondCardController: CreditOrDebitCardPaymentController
    
    private let totalPrice: Double = OderoPay.getCheckoutForm().getCheckoutPriceRaw()
    
    private var _firstAmount: Double = 0
    
    var firstAmount: Double {
        get {
            return _firstAmount
        }
        set {
            if newValue < totalPrice {
                _firstAmount = newValue
            } else {
                print("Cannot set to more than total price")
            }
        }
    }
    
    var secondAmount: Double {
        totalPrice - firstAmount
    }
    
    var isformEnabled: Bool = false
    
    var firstVerticalDividerHeight: CGFloat {
        firstCardController.height + (secondCardController.isformEnabled ? 60 : 75)
    }
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }
        
        return firstCardController.height + secondCardController.height + 166
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    var firstCircleImage: UIImage {
        firstCardController.isPaymentComplete ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "1.circle.fill")!
    }
    
    var secondCircleImage: UIImage {
        secondCardController.isPaymentComplete ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "2.circle.fill")!
    }
    
    init(_ firstCardController: CreditOrDebitCardPaymentController, and secondCardController: CreditOrDebitCardPaymentController) {
        self.firstCardController = firstCardController
        self.secondCardController = secondCardController
        
        self.firstCardController.isformEnabled = true
        self.secondCardController.isformEnabled = false
        
        self.firstCardController.cardController.controllerType = .MULTI_FIRST
        self.secondCardController.cardController.controllerType = .MULTI_SECOND
        
        self.firstAmount = 0
    }
    
    func getTotalPrice() -> Double {
        totalPrice
    }
    
    func makeFirstPayment(for price: Double) async throws -> CompletePaymentFormResult {
        let form = CompletePaymentForm(
            paymentType: .MULTI_CARD_PAYMENT,
            orderedAs: 1,
            withPhase: .PRE_AUTH,
            cardPrice: firstCardController.cardController.retrieveInstallmentChoice() == 1 ? price : firstCardController.cardController.retrievePriceWithInstallment(),
            installment: Installment(rawValue: firstCardController.cardController.retrieveInstallmentChoice())!,
            card:
                Card(
                    number: firstCardController.cardController.retrieveCardNumber(),
                    expiringAt: firstCardController.cardController.retrieveExpireDate()!.0,
                    firstCardController.cardController.retrieveExpireDate()!.1,
                    withCode: firstCardController.cardController.retrieveCVC(),
                    belongsTo: firstCardController.cardController.retrieveCardHolder(),
                    shouldBeStored: firstCardController.cardController.retrieveSaveCardChoiceOption()
                )
        )
        
        OderoPay.setCompletePaymentForm(to: form)
        
        let completePaymentFormResponse: CompletePaymentFormResult

        if firstCardController.cardController.retrieveForce3DSChoiceOption() {
            completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
            print("\n⚠️ 3DS PAYMENT - MULTICARD PAYMENT (CARD #1) ⚠️\n")
        } else {
            completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
            print("\n⚠️ NON-3DS PAYMENT - MULTICARD PAYMENT (CARD #1) ⚠️\n")
        }
        
        return completePaymentFormResponse
    }
    
    func makeSecondPayment(for price: Double) async throws -> CompletePaymentFormResult {
        
        let form = CompletePaymentForm(
                            paymentType: .MULTI_CARD_PAYMENT,
                            orderedAs: 2,
                            withPhase: .PRE_AUTH,
                            cardPrice: secondCardController.cardController.retrieveInstallmentChoice() == 1 ? price : secondCardController.cardController.retrievePriceWithInstallment(),
                            installment: Installment(rawValue: secondCardController.cardController.retrieveInstallmentChoice())!,
                            card:
                                Card(
                                    number: secondCardController.cardController.retrieveCardNumber(),
                                    expiringAt: secondCardController.cardController.retrieveExpireDate()!.0,
                                    secondCardController.cardController.retrieveExpireDate()!.1,
                                    withCode: secondCardController.cardController.retrieveCVC(),
                                    belongsTo: secondCardController.cardController.retrieveCardHolder(),
                                    shouldBeStored: secondCardController.cardController.retrieveSaveCardChoiceOption()
                                )
        )

        OderoPay.setCompletePaymentForm(to: form)
        
        let completePaymentFormResponse: CompletePaymentFormResult

        if secondCardController.cardController.retrieveForce3DSChoiceOption() {
            completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
            print("\n⚠️ 3DS PAYMENT - MULTICARD PAYMENT (CARD #2) ⚠️\n")
        } else {
            completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
            print("\n⚠️ NON-3DS PAYMENT - MULTICARD PAYMENT (CARD #2) ⚠️\n")
        }

        return completePaymentFormResponse
    }
}
