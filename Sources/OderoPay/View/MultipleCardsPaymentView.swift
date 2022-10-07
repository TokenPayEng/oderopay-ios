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
        var isFirstPaymentSuccessful: Bool = false
        var isSecondPaymentSuccessful: Bool = false
        
        if  !multipleCardsPaymentController!.secondCardController.isformEnabled && multipleCardsPaymentController!.firstCardController.isPaymentComplete {

            guard let firstCardPrice = Double(firstAmountTextField.text!.dropLast(5)) else { return }
            
            if firstCardPrice == 0 {
                showErrorAlert(ofType: .MISSING_DATA, .NOW)
                return
            }
            
            let form = CompletePaymentForm(
                                paymentType: .MULTI_CARD_PAYMENT,
                                orderedAs: 1,
                                withPhase: .PRE_AUTH,
                                cardPrice: firstCardPrice,
                                installment: Installment(rawValue: multipleCardsPaymentController!.firstCardController.cardController.retrieveInstallmentChoice())!,
                                card:
                                    Card(
                                        number: multipleCardsPaymentController!.firstCardController.cardController.retrieveCardNumber(),
                                        expiringAt: multipleCardsPaymentController!.firstCardController.cardController.retrieveExpireDate()!.0,
                                        multipleCardsPaymentController!.firstCardController.cardController.retrieveExpireDate()!.1,
                                        withCode: multipleCardsPaymentController!.firstCardController.cardController.retrieveCVC(),
                                        belongsTo: multipleCardsPaymentController!.firstCardController.cardController.retrieveCardHolder(),
                                        shouldBeStored: multipleCardsPaymentController!.firstCardController.cardController.retrieveSaveCardChoiceOption()
                                    )
            )

            OderoPay.setCompletePaymentForm(to: form)

            Task {
                do {
                    let completePaymentFormResponse: CompletePaymentFormResult

                    if multipleCardsPaymentController!.firstCardController.cardController.retrieveForce3DSChoiceOption() {
                        completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
                        print("\n⚠️ 3DS PAYMENT - MULTICARD PAYMENT (CARD #1) ⚠️\n")
                    } else {
                        completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
                        print("\n⚠️ NON-3DS PAYMENT - MULTICARD PAYMENT (CARD #1) ⚠️\n")
                    }

                    if completePaymentFormResponse.hasErrors() != nil {
                        print("complete payment form returned with errors --- FAIL ❌")
                        print("Error code: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()))")
                        print("Error description: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorDescription()))")

                        showErrorAlert(ofType: .SERVER, .NOW)

                        return
                    }

                    guard let resultFromServer = completePaymentFormResponse.hasData() else {
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
                    isFirstPaymentSuccessful = !decodedContent.contains("error")

                    if isFirstPaymentSuccessful {
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
                    } else {
                        firstVerticalDividerView.backgroundColor = OderoColors.error.color
                        firstCircleImageView.tintColor = OderoColors.error.color
                    }
                    
                } catch {
                    print("network error occured ---- FAIL ❌")
                    print("HINT: \(error)")

                    showErrorAlert(ofType: .NETWORK, .LATER)

                    return
                }
            }
        }
        
        if multipleCardsPaymentController!.secondCardController.isPaymentComplete {
            
            guard let secondCardPrice = Double(secondAmountTextField.text!.dropLast(5)) else { return }
            
            let form = CompletePaymentForm(
                                paymentType: .MULTI_CARD_PAYMENT,
                                orderedAs: 2,
                                withPhase: .PRE_AUTH,
                                cardPrice: secondCardPrice,
                                installment: Installment(rawValue: multipleCardsPaymentController!.secondCardController.cardController.retrieveInstallmentChoice())!,
                                card:
                                    Card(
                                        number: multipleCardsPaymentController!.secondCardController.cardController.retrieveCardNumber(),
                                        expiringAt: multipleCardsPaymentController!.secondCardController.cardController.retrieveExpireDate()!.0,
                                        multipleCardsPaymentController!.secondCardController.cardController.retrieveExpireDate()!.1,
                                        withCode: multipleCardsPaymentController!.secondCardController.cardController.retrieveCVC(),
                                        belongsTo: multipleCardsPaymentController!.secondCardController.cardController.retrieveCardHolder(),
                                        shouldBeStored: multipleCardsPaymentController!.secondCardController.cardController.retrieveSaveCardChoiceOption()
                                    )
            )

            OderoPay.setCompletePaymentForm(to: form)
            
            
            Task {
                do {
                    let completePaymentFormResponse: CompletePaymentFormResult

                    if multipleCardsPaymentController!.secondCardController.cardController.retrieveForce3DSChoiceOption() {
                        completePaymentFormResponse = try await OderoPay.sendComplete3DSPaymentForm()
                        print("\n⚠️ 3DS PAYMENT - MULTICARD PAYMENT (CARD #2) ⚠️\n")
                    } else {
                        completePaymentFormResponse = try await OderoPay.sendCompletePaymentForm()
                        print("\n⚠️ NON-3DS PAYMENT - MULTICARD PAYMENT (CARD #2) ⚠️\n")
                    }

                    if completePaymentFormResponse.hasErrors() != nil {
                        print("complete payment form returned with errors --- FAIL ❌")
                        print("Error code: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorCode()))")
                        print("Error description: \(String(describing: completePaymentFormResponse.hasErrors()?.getErrorDescription()))")

                        showErrorAlert(ofType: .SERVER, .NOW)

                        return
                    }

                    guard let resultFromServer = completePaymentFormResponse.hasData() else {
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
                    isSecondPaymentSuccessful = !decodedContent.contains("error")

                    if isSecondPaymentSuccessful {
                        multipleCardsPaymentController!.secondCardController.isformEnabled = false
                        
                        secondCardView.isHidden = true
                        
                        secondVerticalDividerView.backgroundColor = OderoColors.success.color
                        
                        secondCircleImageView.image = multipleCardsPaymentController!.secondCircleImage
                        secondCircleImageView.tintColor = OderoColors.success.color
                        
                        OderoPay.setPaymentStatus(to: isFirstPaymentSuccessful && isSecondPaymentSuccessful)
                        NotificationCenter.default.post(name: Notification.Name("callPaymentInformation"), object: nil)
                    } else {
                        secondVerticalDividerView.backgroundColor = OderoColors.error.color
                        secondCircleImageView.tintColor = OderoColors.error.color
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
