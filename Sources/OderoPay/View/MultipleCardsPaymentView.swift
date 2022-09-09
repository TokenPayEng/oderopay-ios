//
//  MultipleCardsPaymentView.swift
//  
//
//  Created by Imran Hajiyev on 02.08.22.
//

import UIKit

class MultipleCardsPaymentView: UIView, UITextFieldDelegate {
    
    var multipleCardsPaymentController: MultipleCardsPaymentController? = nil
    lazy private var successCGColor = UIColor(red: 108/255, green: 209/255, blue: 78/255, alpha: 1).cgColor
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstCardAmountLabel: UILabel!
    @IBOutlet weak var secondCardAmountLabel: UILabel!
    
    @IBOutlet weak var firstCircleImageView: UIImageView!
    @IBOutlet weak var firstAmountTextField: UITextField!
//        didSet {
//            firstAmountTextField.addPreviousNextToolbar(
//                onNext: (
//                    target: self,
//                    action: #selector(moveNextTextField)
//                ),
//                onPrevious: (
//                    target: self,
//                    action: #selector(movePreviousTextField)
//                )
//            )
//
//            firstAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrency())"
//        }
    @IBOutlet weak var firstVerticalDividerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondCircleImageView: UIImageView!
    @IBOutlet weak var secondAmountTextField: UITextField!
//        didSet {
//            secondAmountTextField.addPreviousNextToolbar(
//                onNext: (
//                    target: self,
//                    action: #selector(moveNextTextField)
//                ),
//                onPrevious: (
//                    target: self,
//                    action: #selector(movePreviousTextField)
//                )
//            )
//
//            secondAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrency())"
//        }

    @IBOutlet weak var firstCardView: CreditOrDebitCardPaymentView!
    @IBOutlet weak var secondCardView: CreditOrDebitCardPaymentView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("MultipleCardsPayment", owner: self, options: nil)
        
        multipleCardsPaymentController = MultipleCardsPaymentController(firstCardView.creditOrDebitCardPaymentController!, and: secondCardView.creditOrDebitCardPaymentController!)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
    
        self.firstAmountTextField.delegate = self
        self.secondAmountTextField.delegate = self
        
        firstCardAmountLabel.text = NSLocalizedString(
            "firstCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the first credit card"
        )
//        firstCardInformationView.cardNumberTextField.addPreviousNextToolbar(
//            onNext: (
//                target: self,
//                action: #selector(moveNextTextField)
//            ),
//            onPrevious: (
//                target: self,
//                action: #selector(movePreviousTextField)
//            )
//        )
//
//        firstCardInformationView.cardholderTextField.addPreviousNextToolbar(
//            onNext: (
//                target: self,
//                action: #selector(moveNextTextField)
//            ),
//            onPrevious: (
//                target: self,
//                action: #selector(movePreviousTextField)
//            )
//        )
        
        secondCardAmountLabel.text = NSLocalizedString(
            "secondCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the second credit card"
        )
        
//        secondCardInformationView.cardNumberTextField.addPreviousNextToolbar(
//            onNext: (
//                target: self,
//                action: #selector(moveNextTextField)
//            ),
//            onPrevious: (
//                target: self,
//                action: #selector(movePreviousTextField)
//            )
//        )
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = successCGColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        
        if textField == firstAmountTextField || textField == secondAmountTextField {
            if textField.text!.isEmpty { textField.isError(true) }
        } else {
            textField.isError(false)
        }
    }
    
//    @objc func moveNextTextField() {
//        if firstAmountTextField.isFirstResponder {
//            firstCardInformationView.cardNumberTextField.becomeFirstResponder()
//        } else if firstCardInformationView.cardholderTextField.isFirstResponder {
//            secondAmountTextField.becomeFirstResponder()
//        } else if secondAmountTextField.isFirstResponder {
//            secondCardInformationView.cardNumberTextField.becomeFirstResponder()
//        } else if firstCardInformationView.cardNumberTextField.isFirstResponder {
//            firstCardInformationView.expireDateTextField.becomeFirstResponder()
//        } else if secondCardInformationView.cardNumberTextField.isFirstResponder {
//            secondCardInformationView.expireDateTextField.becomeFirstResponder()
//        }
//    }
//
//    @objc func movePreviousTextField() {
//        if firstCardInformationView.cardNumberTextField.isFirstResponder {
//            firstAmountTextField.becomeFirstResponder()
//        } else if secondAmountTextField.isFirstResponder {
//            firstCardInformationView.cardholderTextField.becomeFirstResponder()
//        } else if secondCardInformationView.cardNumberTextField.isFirstResponder {
//            secondAmountTextField.becomeFirstResponder()
//        } else if firstCardInformationView.cardholderTextField.isFirstResponder {
//            firstCardInformationView.cvcTextField.becomeFirstResponder()
//        } else if firstAmountTextField.isFirstResponder {
//            firstAmountTextField.resignFirstResponder()
//        }
//    }
}
