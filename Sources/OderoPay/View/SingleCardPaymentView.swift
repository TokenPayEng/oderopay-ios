//
//  SingleCardPaymentView.swift
//  
//
//  Created by Imran Hajiyev on 14.09.22.
//

import UIKit

class SingleCardPaymentView: UIView {
    
    var singleCardPaymentController: SingleCardPaymentController? = nil

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardView: CreditOrDebitCardPaymentView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @objc func updateOnPaymentComplete() {
        if singleCardPaymentController!.cardController.isPaymentComplete {
    
            let form = CompletePaymentForm(
                                paymentType: .CARD_PAYMENT,
                                cardPrice: OderoPay.getCheckoutForm().getCheckoutPriceRaw(),
                                installment: Installment(rawValue: singleCardPaymentController!.cardController.cardController.retrieveInstallmentChoice())!,
                                card:
                                    Card(
                                        number: singleCardPaymentController!.cardController.cardController.retrieveCardNumber(),
                                        expiringAt: singleCardPaymentController!.cardController.cardController.retrieveExpireDate()!.0,
                                        singleCardPaymentController!.cardController.cardController.retrieveExpireDate()!.1,
                                        withCode: singleCardPaymentController!.cardController.cardController.retrieveCVC(),
                                        belongsTo: singleCardPaymentController!.cardController.cardController.retrieveCardHolder(),
                                        shouldBeStored: singleCardPaymentController!.cardController.cardController.retrieveSaveCardChoiceOption()
                                    )
            )
            
            OderoPay.setCompletePaymentForm(to: form)

            Task {
                do {
                    let completePaymentFormResponse: CompletePaymentFormResult
                    
                    if singleCardPaymentController!.cardController.cardController.retrieveForce3DSChoiceOption() {
                        completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
                        print("\n⚠️ 3DS PAYMENT ⚠️\n")
                    } else {
                        completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
                        print("\n⚠️ NON-3DS PAYMENT ⚠️\n")
                    }
                    
                    if completePaymentFormResponse.hasErrors() != nil {
                        print("complete payment form returned with errors --- FAIL ❌")
                        print("Error code: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()))")
                        print("Error description: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorDescription()))")

                        if String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()) == "4999" {
                            print(String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()))
                            showErrorAlert(ofType: .INSUFFICIENT_FUNDS, .FUNDS)
                        } else {
                            print("here")
                            showErrorAlert(ofType: .SERVER, .NOW)
                        }

                        return
                    }
                    
                    guard let resultFromServer = completePaymentFormResponse.hasData() else {
                        print("Error occured ---- FAIL ❌")
                        print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")

                        showErrorAlert(ofType: .SERVER, .LATER)

                        return
                    }
                    
                    print("retrieving content...")
                    let content = resultFromServer.getHtmlContent()
                    print("content retrieved ---- SUCCESS ✅")
                    let decodedContent = String(data: Data(base64Encoded: content)!, encoding: .utf8) ?? "error"
                    print("complete payment form sent ---- SUCCESS ✅\n")
                    
                    OderoPay.setPaymentStatus(to: !decodedContent.contains("error"))
                    
                    NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
                } catch {
                    print("network error occured ---- FAIL ❌")
                    print("HINT: \(error)")

                    showErrorAlert(ofType: .NETWORK, .LATER)

                    return
                }
            }
        }
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("SingleCardPayment", owner: self, options: nil)
        
        singleCardPaymentController = SingleCardPaymentController(cardView.creditOrDebitCardPaymentController!)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnPaymentComplete), name: NSNotification.Name(rawValue: "completePayment"), object: nil)
        
        cardView.isHidden = !singleCardPaymentController!.cardController.isformEnabled
    }
}
