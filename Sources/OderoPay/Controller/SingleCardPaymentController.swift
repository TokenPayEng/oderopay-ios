//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 14.09.22.
//

import Foundation
import UIKit

class SingleCardPaymentController: FormProtocol {
    
    var cardController: CreditOrDebitCardPaymentController
    
    var isformEnabled: Bool = false
    
    var height: CGFloat {
        if !isformEnabled {
            return 0
        }

        return cardController.height
    }
    
    var image: UIImage {
        isformEnabled ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
    }
    
    init(_ cardController: CreditOrDebitCardPaymentController) {
        self.cardController = cardController
        self.cardController.isformEnabled = true
        self.cardController.cardController.controllerType = .SINGLE_CREDIT
    }
    
    func makePayment() async throws -> CompletePaymentFormResult? {
        if cardController.isPaymentComplete {
            let form = CompletePaymentForm(
                paymentType: .CARD_PAYMENT,
                cardPrice: OderoPay.getCheckoutForm().getCheckoutPriceRaw(),
                installment: Installment(rawValue: cardController.cardController.retrieveInstallmentChoice())!,
                card:
                    Card(
                        number: cardController.cardController.retrieveCardNumber(),
                        expiringAt: cardController.cardController.retrieveExpireDate()!.0,
                        cardController.cardController.retrieveExpireDate()!.1,
                        withCode: cardController.cardController.retrieveCVC(),
                        belongsTo: cardController.cardController.retrieveCardHolder(),
                        shouldBeStored: cardController.cardController.retrieveSaveCardChoiceOption()
                    )
            )
            
            OderoPay.setCompletePaymentForm(to: form)
            
            let completePaymentFormResponse: CompletePaymentFormResult
            
            if cardController.cardController.retrieveForce3DSChoiceOption() {
                print("\n⚠️ 3DS PAYMENT ⚠️\n")
                completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
            } else {
                print("\n⚠️ NON-3DS PAYMENT ⚠️\n")
                completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
            }
            
            return completePaymentFormResponse
        }
        
        return nil
    }
}
