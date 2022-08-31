//
//  CreditOrDebitCardPayemnt.swift
//  
//
//  Created by Imran Hajiyev on 01.08.22.
//

import UIKit

class CreditOrDebitCardPayment: UIView {
    
    static var height: CGFloat = 220

    var isEnabled: Bool = true

    @IBOutlet var contentView: UIView!
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
    
    public func setSectionEnabled(_ value: Bool) {
        isEnabled = value
    }
}
