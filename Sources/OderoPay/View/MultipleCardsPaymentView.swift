//
//  MultipleCardsPaymentView.swift
//  
//
//  Created by Imran Hajiyev on 02.08.22.
//

import UIKit

class MultipleCardsPaymentView: UIView, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var firstAmountTextField: UITextField! {
        didSet {
            firstAmountTextField.addNextToolbar(onNext: (target: self, action: #selector(customNextTapped)))
        }
    }
                                                                 
    @IBOutlet weak var secondAmountTextField: UITextField! {
        didSet {
            secondAmountTextField.addPreviousNextToolbar()
        }
    }
    
    @IBOutlet weak var firstCardInformationView: CardInformationView! {
        didSet {
            firstCardInformationView.cardNumberTextField.addPreviousToolbar()
            firstCardInformationView.cardNumberTextField.tag = 7
            firstCardInformationView.expireDateTextField.tag = 6
            firstCardInformationView.cvcTextField.tag = 8
            firstCardInformationView.cardholderTextField.tag = 9
            
            print(firstCardInformationView.cardholderTextField.tag)
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
        
        self.firstAmountTextField.delegate = self
        self.secondAmountTextField.delegate = self
    }
    
    @objc func customNextTapped() {
        let nextTag = self.tag + 1
        
        if let nextResponder = self.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    
    @objc func customPreviousTapped() {
        let previousTag = self.tag - 1
        
        if let previousResponder = self.superview?.viewWithTag(previousTag) {
            previousResponder.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
}
