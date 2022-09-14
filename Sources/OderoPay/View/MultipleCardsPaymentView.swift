//
//  MultipleCardsPaymentView.swift
//  
//
//  Created by Imran Hajiyev on 02.08.22.
//

import UIKit

class MultipleCardsPaymentView: UIView, UITextFieldDelegate {
    
    var multipleCardsPaymentController: MultipleCardsPaymentController? = nil
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstCardAmountLabel: UILabel!
    @IBOutlet weak var secondCardAmountLabel: UILabel!
    
    @IBOutlet weak var firstCircleImageView: UIImageView!
    @IBOutlet weak var firstAmountTextField: UITextField!
    
    @IBOutlet weak var firstVerticalDividerView: UIView!
    @IBOutlet weak var secondVerticalDividerView: UIView!
    
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
    
    @objc func updateOnPaymentComplete() {
        if  !multipleCardsPaymentController!.secondCardController.isformEnabled && multipleCardsPaymentController!.firstCardController.isPaymentComplete {
            multipleCardsPaymentController!.firstCardController.isformEnabled = false
            multipleCardsPaymentController!.secondCardController.isformEnabled = true
            
            firstCardView.isHidden = true
            secondCardView.isHidden = false
            
            firstVerticalDividerView.backgroundColor = OderoColors.success.color
            
            firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
            
            firstAmountTextField.isEnabled = false
            firstAmountTextField.backgroundColor = OderoColors.gray.color
            
            firstCircleImageView.image = multipleCardsPaymentController!.firstCircleImage
            firstCircleImageView.tintColor = OderoColors.success.color

            secondCircleImageView.tintColor = multipleCardsPaymentController!.secondCardController.isformEnabled ? OderoColors.black.color : .systemGray4
            
            NotificationCenter.default.post(name: Notification.Name("update2Height"), object: nil)
        }
        
        if multipleCardsPaymentController!.secondCardController.isPaymentComplete {
            multipleCardsPaymentController!.secondCardController.isformEnabled = false
            
            secondCardView.isHidden = true
            
            secondVerticalDividerView.backgroundColor = OderoColors.success.color
            
            secondCircleImageView.image = multipleCardsPaymentController!.secondCircleImage
            secondCircleImageView.tintColor = OderoColors.success.color
            
            NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
        }
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("MultipleCardsPayment", owner: self, options: nil)
        
        multipleCardsPaymentController = MultipleCardsPaymentController(firstCardView.creditOrDebitCardPaymentController!, and: secondCardView.creditOrDebitCardPaymentController!)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.firstAmountTextField.delegate = self
        self.secondAmountTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnPaymentComplete), name: NSNotification.Name(rawValue: "completePayment"), object: nil)
        
        firstCardView.isHidden = !multipleCardsPaymentController!.firstCardController.isformEnabled
        secondCardView.isHidden = !multipleCardsPaymentController!.secondCardController.isformEnabled
        
        firstCircleImageView.image = multipleCardsPaymentController!.firstCircleImage
        secondCircleImageView.image = multipleCardsPaymentController!.secondCircleImage
        firstCircleImageView.tintColor = multipleCardsPaymentController!.firstCardController.isformEnabled ? OderoColors.black.color : .systemGray4
        secondCircleImageView.tintColor = multipleCardsPaymentController!.secondCardController.isformEnabled ? OderoColors.black.color : .systemGray4
        
        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
        
        firstAmountTextField.addNextToolbar(
            onNext: (
                target: self,
                action: #selector(moveNextTextField)
            )
        )
        secondAmountTextField.addNextToolbar(
            onNext: (
                target: self,
                action: #selector(moveNextTextField)
            )
        )

        firstAmountTextField.placeholder = "\(String(format: "%.2f", multipleCardsPaymentController!.firstAmount)) \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
        secondAmountTextField.text = "\(String(format: "%.2f", multipleCardsPaymentController!.secondAmount)) \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
        secondAmountTextField.backgroundColor = OderoColors.gray.color
        
        firstCardAmountLabel.text = NSLocalizedString(
            "firstCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the first credit card"
        )
        secondCardAmountLabel.text = NSLocalizedString(
            "secondCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the second credit card"
        )
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = OderoColors.success.cgColor
        
        if textField == firstAmountTextField {
            if textField.text!.contains(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign) {
                textField.text! = String(textField.text!.dropLast(5))
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        
        if textField == firstAmountTextField {
            if textField.text!.isEmpty { textField.isError(true) }
            else {
                textField.isError(false)
                textField.text = String(format: "%.2f", multipleCardsPaymentController!.firstAmount)
                textField.text!.append(" \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)")
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == firstAmountTextField {
            guard let currentInput = textField.text as? NSString else { return false }
            let updatedInput = currentInput.replacingCharacters(in: range, with: string)
            
   
            multipleCardsPaymentController!.firstAmount = Double(updatedInput) ?? 0
            
            secondAmountTextField.text = String(format: "%.2f", multipleCardsPaymentController!.secondAmount)
            secondAmountTextField.text!.append(" \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)")
            
            if Double(updatedInput) ?? 0 > multipleCardsPaymentController!.getTotalPrice() {
                return false
            }
            
        }
        
        return true
    }
    
    @objc func moveNextTextField() {
        if firstAmountTextField.isFirstResponder {
            firstCardView.cardInformationView.cardNumberTextField.becomeFirstResponder()
        } else if secondAmountTextField.isFirstResponder {
            secondCardView.cardInformationView.cardNumberTextField.becomeFirstResponder()
        }
    }
}
