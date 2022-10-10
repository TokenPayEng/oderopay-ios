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
        
        // ----------------------------FIRST CARD-------------------------------
        if  !multipleCardsPaymentController!.secondCardController.isformEnabled && multipleCardsPaymentController!.firstCardController.isPaymentComplete {
            
            guard let firstCardPrice = Double(firstAmountTextField.text!.dropLast(5)) else { return }
            
            if firstCardPrice == 0 {
                showErrorAlert(ofType: .MISSING_DATA, .NOW)
                return
            }

            Task {
                do {
                    let response: CompletePaymentFormResult = try await multipleCardsPaymentController!.makeFirstPayment(for: firstCardPrice)

                    if response.hasErrors() != nil {
                        print("complete payment form returned with errors --- FAIL ❌")
                        print("Error code: \(String(describing: response.hasErrors()?.getErrorCode()))")
                        print("Error description: \(String(describing: response.hasErrors()?.getErrorDescription()))")

                        showErrorAlert(ofType: .SERVER, .NOW)
                        firstVerticalDividerView.backgroundColor = OderoColors.error.color
                        firstCircleImageView.tintColor = OderoColors.error.color
                        return
                    }

                    guard let resultFromServer = response.hasData() else {
                        print("Error occured ---- FAIL ❌")
                        print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")

                        showErrorAlert(ofType: .SERVER, .LATER)
                        firstVerticalDividerView.backgroundColor = OderoColors.error.color
                        firstCircleImageView.tintColor = OderoColors.error.color
                        return
                    }

                    print("retrieving content...")
                    let content = resultFromServer.getHtmlContent()
                    print("content retrieved ---- SUCCESS ✅")
                    let decodedContent = String(data: Data(base64Encoded: content)!, encoding: .utf8) ?? "error"
                    print("complete payment form sent ---- SUCCESS ✅\n")
                    
                    // first check for 3ds
                    if multipleCardsPaymentController!.firstCardController.cardController.retrieveForce3DSChoiceOption() {
                        NotificationCenter.default.post(name: Notification.Name("callPaymentInformation3DS"), object: nil, userInfo: ["content": decodedContent, "type": CardControllers.MULTI_FIRST])
                        print("\nStarted 3DS Verification for the First of the Multiple Cards Payment\n")
                        
                        let isFirstPaymentSuccessful = OderoPay.areMultipleCardsPaymentsCompleted().0
                        
                        multipleCardsPaymentController!.firstCardController.isformEnabled = false
                        multipleCardsPaymentController!.secondCardController.isformEnabled = true
                        
                        firstCardView.isHidden = true
                        secondCardView.isHidden = false
                        
                        firstVerticalDividerView.backgroundColor = isFirstPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
                        
                        firstAmountTextField.isEnabled = false
                        firstAmountTextField.backgroundColor = OderoColors.gray.color
                        
                        firstCircleImageView.image = isFirstPaymentSuccessful ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "x.circle.fill")!
                        
                        firstCircleImageView.tintColor = isFirstPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        secondCircleImageView.tintColor = multipleCardsPaymentController!.secondCardController.isformEnabled ? OderoColors.black.color : .systemGray4
                    } else {
                        OderoPay.setMultipleCardsPaymentOneStatus(to: !decodedContent.contains("error"))
                        let isFirstPaymentSuccessful = OderoPay.areMultipleCardsPaymentsCompleted().0

                        multipleCardsPaymentController!.firstCardController.isformEnabled = false
                        multipleCardsPaymentController!.secondCardController.isformEnabled = true
                        
                        firstCardView.isHidden = true
                        secondCardView.isHidden = false
                        
                        firstVerticalDividerView.backgroundColor = isFirstPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        firstVerticalDividerHeightConstraint.constant = multipleCardsPaymentController!.firstVerticalDividerHeight
                        
                        firstAmountTextField.isEnabled = false
                        firstAmountTextField.backgroundColor = OderoColors.gray.color
                        
                        firstCircleImageView.image = isFirstPaymentSuccessful ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "x.circle.fill")!
                        
                        firstCircleImageView.tintColor = isFirstPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color

                        secondCircleImageView.tintColor = multipleCardsPaymentController!.secondCardController.isformEnabled ? OderoColors.black.color : .systemGray4
                        
                        NotificationCenter.default.post(name: Notification.Name("update2Height"), object: nil)
                    }
                    
                } catch {
                    print("network error occured ---- FAIL ❌")
                    print("HINT: \(error)")

                    showErrorAlert(ofType: .NETWORK, .LATER)
                    firstVerticalDividerView.backgroundColor = OderoColors.error.color
                    firstCircleImageView.tintColor = OderoColors.error.color
                    return
                }
            }
        }
        
        // ----------------------------SECOND CARD-------------------------------
        if multipleCardsPaymentController!.secondCardController.isPaymentComplete {
            
            guard let secondCardPrice = Double(secondAmountTextField.text!.dropLast(5)) else { return }
            
            Task {
                do {
                    let response: CompletePaymentFormResult = try await multipleCardsPaymentController!.makeSecondPayment(for: secondCardPrice)

                    if response.hasErrors() != nil {
                        print("complete payment form returned with errors --- FAIL ❌")
                        print("Error code: \(String(describing: response.hasErrors()?.getErrorCode()))")
                        print("Error description: \(String(describing: response.hasErrors()?.getErrorDescription()))")

                        showErrorAlert(ofType: .SERVER, .NOW)

                        return
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
                    if multipleCardsPaymentController!.firstCardController.cardController.retrieveForce3DSChoiceOption() {
                        NotificationCenter.default.post(name: Notification.Name("callPaymentInformation3DS"), object: nil, userInfo: ["content": decodedContent, "type": CardControllers.MULTI_SECOND])
                        print("\nStarted 3DS Verification for the Second of the Multiple Cards Payment\n")
                        let isSecondPaymentSuccessful = OderoPay.areMultipleCardsPaymentsCompleted().1
                        
                        multipleCardsPaymentController!.secondCardController.isformEnabled = false
                        
                        secondCardView.isHidden = true
                        
                        secondVerticalDividerView.backgroundColor = isSecondPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        secondCircleImageView.image = isSecondPaymentSuccessful ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "x.circle.fill")!
                        secondCircleImageView.tintColor = isSecondPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                    } else {
                        OderoPay.setMultipleCardsPaymentTwoStatus(to: !decodedContent.contains("error"))
                        let isSecondPaymentSuccessful = OderoPay.areMultipleCardsPaymentsCompleted().1
                        
                        multipleCardsPaymentController!.secondCardController.isformEnabled = false
                        
                        secondCardView.isHidden = true
                        
                        secondVerticalDividerView.backgroundColor = isSecondPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        secondCircleImageView.image = isSecondPaymentSuccessful ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "x.circle.fill")!
                        secondCircleImageView.tintColor = isSecondPaymentSuccessful ? OderoColors.success.color : OderoColors.error.color
                        
                        OderoPay.setPaymentStatus(to: OderoPay.areMultipleCardsPaymentsCompleted().0 && OderoPay.areMultipleCardsPaymentsCompleted().1)
                        
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
                OderoPay.setPriceForFirstMultiCard(Double(textField.text!)!)
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
