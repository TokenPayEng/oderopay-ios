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
    
    func makePayment() async throws -> (ErrorTypes?, ErrorDescriptions?) {
        var errorType: ErrorTypes? = nil
        var errorDescription: ErrorDescriptions? = nil
        
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
            
            if completePaymentFormResponse.hasErrors() != nil {
                print("complete payment form returned with errors --- FAIL ❌")
                print("Error code: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()))")
                print("Error description: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorDescription()))")
                
                if completePaymentFormResponse.hasErrors()?.getErrorCode() == "4999" {
                    errorType = .INSUFFICIENT_FUNDS
                    errorDescription = .FUNDS
                    return (errorType, errorDescription)
                } else {
                    errorType = .SERVER
                    errorDescription = .NOW
                    return (errorType, errorDescription)
                }
            }
            
            guard let resultFromServer = completePaymentFormResponse.hasData() else {
                print("Error occured ---- FAIL ❌")
                print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")
                
                errorType = .SERVER
                errorDescription = .LATER
                return (errorType, errorDescription)
            }
            
            print("retrieving content...")
            let content = resultFromServer.getHtmlContent()
            print("content retrieved ---- SUCCESS ✅")
            let decodedContent = String(data: Data(base64Encoded: content)!, encoding: .utf8) ?? "error"
            print("complete payment form sent ---- SUCCESS ✅\n")
            
            OderoPay.setPaymentStatus(to: !decodedContent.contains("error"))
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
            }
        }
        
        return (errorType, errorDescription)
    }
}
