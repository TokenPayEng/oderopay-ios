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
        Task {
            do {
                let response: CompletePaymentFormResult? = try await singleCardPaymentController!.makePayment()
                
                guard let response = response else { return }
                
                if response.hasErrors() != nil {
                    print("complete payment form returned with errors --- FAIL ❌")
                    print("Error code: \(String(describing: response.hasErrors()?.getErrorCode()))")
                    print("Error description: \(String(describing: response.hasErrors()?.getErrorDescription()))")
                    
                    if response.hasErrors()?.getErrorCode() == "4999" {
                        showErrorAlert(ofType: .INSUFFICIENT_FUNDS, .FUNDS)
                        return
                    } else {
                        showErrorAlert(ofType: .SERVER, .NOW)
                        return
                    }
                }
                
                guard let resultFromServer = response.hasData() else {
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
                
                // first check for 3ds
                if singleCardPaymentController!.cardController.cardController.retrieveForce3DSChoiceOption() {
                    NotificationCenter.default.post(name: Notification.Name("callPaymentInformation3DS"), object: nil, userInfo: ["content": decodedContent, "type": CardControllers.SINGLE_CREDIT])
                    print("\nStarted 3DS Verification for Single Card Payment\n")
                } else {
                    OderoPay.setPaymentStatus(to: !decodedContent.contains("error"))
                    NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
                }
            } catch {
                print("network error occured ---- FAIL ❌")
                print("HINT: \(error)")

                showErrorAlert(ofType: .NETWORK, .LATER)

                return
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
