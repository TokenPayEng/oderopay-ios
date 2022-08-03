//
//  MultipleCardsPaymentView.swift
//  
//
//  Created by Imran Hajiyev on 02.08.22.
//

import UIKit

class MultipleCardsPaymentView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstCardAmountLabel: UILabel! {
        didSet {
            firstCardAmountLabel.text = NSLocalizedString(
                "firstCardAmount",
                bundle: Bundle.module,
                comment: "amount of money to be paid from the first credit card"
            )
        }
    }
    @IBOutlet weak var secondCardAmountLabel: UILabel! {
        didSet {
            secondCardAmountLabel.text = NSLocalizedString(
                "secondCardAmount",
                bundle: Bundle.module,
                comment: "amount of money to be paid from the second credit card"
            )
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
        Bundle.module.loadNibNamed("MultipleCardsPayment", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
