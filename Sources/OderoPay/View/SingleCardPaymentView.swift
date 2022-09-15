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
            
            guard let expireDate = singleCardPaymentController!.cardController.cardController.retrieveExpireDate() else { return }

            let form = CompletePaymentForm(
                                paymentType: .CARD_PAYMENT,
                                cardPrice: OderoPay.getCheckoutForm().getCheckoutPriceRaw(),
                                installment: Installment(rawValue: singleCardPaymentController!.cardController.cardController.retrieveInstallmentChoice())!,
                                card:
                                    Card(
                                        number: singleCardPaymentController!.cardController.cardController.retrieveCardNumber(),
                                        expiringAt: expireDate.0,
                                        expireDate.1,
                                        withCode: singleCardPaymentController!.cardController.cardController.retrieveCVC(),
                                        belongsTo: singleCardPaymentController!.cardController.cardController.retrieveCardHolder()
                                    )
            )
            
            
            print(form)
            OderoPay.setCompletePaymentForm(to: form)
            
            //        Task {
            //            do {
            //                print(try await OderoPay.sendCompletePaymentForm().hasData() ?? "no data")
            //                print(try await OderoPay.sendCompletePaymentForm().hasErrors() ?? "no error")
            //            } catch {
            //                print(error)
            //            }
            //        }
            
            NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
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
