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
            firstAmountTextField.addNextToolbar(onNext: (target: self, action: #selector(moveNextTextField)))
        }
    }
                                                                 
    @IBOutlet weak var secondAmountTextField: UITextField! {
        didSet {
            secondAmountTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
        }
    }
    
    @IBOutlet weak var firstCardInformationView: CardInformationView! {
        didSet {
            firstCardInformationView.cardNumberTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
            
            firstCardInformationView.cardholderTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                ))
        }
    }
    
    @IBOutlet weak var secondCardInformationView: CardInformationView! {
        didSet {
            secondCardInformationView.cardNumberTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
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
    
    @objc func moveNextTextField() {
        if firstAmountTextField.isFirstResponder {
            firstCardInformationView.cardNumberTextField.becomeFirstResponder()
        } else if firstCardInformationView.cardholderTextField.isFirstResponder {
            secondAmountTextField.becomeFirstResponder()
        } else if secondAmountTextField.isFirstResponder {
            secondCardInformationView.cardNumberTextField.becomeFirstResponder()
        }
    }
    
    @objc func movePreviousTextField() {
        if firstCardInformationView.cardNumberTextField.isFirstResponder {
            firstAmountTextField.becomeFirstResponder()
        } else if secondAmountTextField.isFirstResponder {
            firstCardInformationView.cardholderTextField.becomeFirstResponder()
        } else if secondCardInformationView.cardNumberTextField.isFirstResponder {
            secondAmountTextField.becomeFirstResponder()
        } else if firstCardInformationView.cardholderTextField.isFirstResponder {
            firstCardInformationView.cvcTextField.becomeFirstResponder()
        }
    }
}
