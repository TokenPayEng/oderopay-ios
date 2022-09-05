//
//  CreditOrDebitCardPayemnt.swift
//  
//
//  Created by Imran Hajiyev on 01.08.22.
//

import UIKit

class CreditOrDebitCardPaymentView: UIView {
    
    var creditOrDebitCardPaymentController: CreditOrDebitCardPaymentController = CreditOrDebitCardPaymentController()
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardInformationView: CardInformationView!
    
    @IBOutlet weak var optionsView: OptionsView! {
        didSet {
            print("called")
            print(!cardInformationView.cardController.isCardValid())
            optionsView.isHidden = !cardInformationView.cardController.isCardValid()
        }
    }
    
    @IBOutlet weak var makePaymentButton: UIButton! {
        didSet {
            makePaymentButton.layer.cornerRadius = 8
            makePaymentButton.setTitle(
                NSLocalizedString(
                    "makePayment",
                    bundle: Bundle.module,
                    comment: "send payment request"
                ),
                for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("CreditOrDebitCardPayment", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
