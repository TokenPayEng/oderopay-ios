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
    @IBOutlet weak var firstVerticalDividerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondCircleImageView: UIImageView!
    @IBOutlet weak var secondAmountTextField: UITextField!

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
        
        firstCardView.isHidden = !multipleCardsPaymentController!.firstCardController.isformEnabled
        secondCardView.isHidden = !multipleCardsPaymentController!.secondCardController.isformEnabled
        
        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
    
        self.firstAmountTextField.delegate = self
        self.secondAmountTextField.delegate = self
        
        firstAmountTextField.addNextToolbar(
            onNext: (
                target: self,
                action: #selector(moveNextTextField)
            )
        )

        firstAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
        
        firstCardAmountLabel.text = NSLocalizedString(
            "firstCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the first credit card"
        )
        
        secondAmountTextField.addNextToolbar(
            onNext: (
                target: self,
                action: #selector(moveNextTextField)
            )
        )

        secondAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
        
        secondCardAmountLabel.text = NSLocalizedString(
            "secondCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the second credit card"
        )
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = successCGColor
        
        if textField == firstAmountTextField {
            if textField.text!.contains(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign) {
                textField.text! = String(textField.text!.dropLast(2))
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        
        if textField == firstAmountTextField {
            if textField.text!.isEmpty { textField.isError(true) }
            else {
                textField.isError(false)
                firstAmountTextField.text = String(format: "%.2f", textField.text!)
                secondAmountTextField.text = String(format: "%.2f", String(OderoPay.getCheckoutForm().getCheckoutPriceRaw() - Double(textField.text!)!))
                textField.text!.append(" \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)")
            }
        }
    }
    
    @objc func moveNextTextField() {
        if firstAmountTextField.isFirstResponder {
            firstCardView.cardInformationView.cardNumberTextField.becomeFirstResponder()
        } else if secondAmountTextField.isFirstResponder {
            secondCardView.cardInformationView.cardNumberTextField.becomeFirstResponder()
        }
    }
}
