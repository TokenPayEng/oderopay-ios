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
    @IBOutlet weak var makePaymentButton: UIButton!
    
    @IBOutlet weak var firstCircleImageView: UIImageView!
    @IBOutlet weak var firstAmountTextField: UITextField! {
        didSet {
            firstAmountTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
            
            firstAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrency())"
        }
    }
    @IBOutlet weak var firstVerticalDividerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondCircleImageView: UIImageView!
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
            
            secondAmountTextField.placeholder = "0.00 \(OderoPay.getCheckoutForm().getCheckoutCurrency())"
        }
    }
    
    @IBOutlet weak var firstCardInformationView: CardInformationView!
    @IBOutlet weak var firstInstallmentView: InstallmentView!
    @IBOutlet weak var firstOptionsView: OptionsView!
    
    @IBOutlet weak var secondCardInformationView: CardInformationView!
    @IBOutlet weak var secondInstallmentView: InstallmentView!
    @IBOutlet weak var secondOptionsView: OptionsView!
    
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
        
        // first card controller
        firstInstallmentView.isHidden = !multipleCardsPaymentController!.hasInstallmentFirstCard
        
        if multipleCardsPaymentController!.hasInstallmentFirstCard {
    
            if !multipleCardsPaymentController!.installmentsEnabledFirstCard {
                firstInstallmentView.installmentOptionsStackView.removeFullyAllArrangedSubviews()
                
                for (index, installmentItem) in multipleCardsPaymentController!.firstCardController.retrieveInstallments().first!.getInstallmentItems().enumerated() {
            
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFirst(_:)))
                    let installmentItemView = InstallmentOptionView()
                    installmentItemView.frame.size = CGSize(width: firstInstallmentView.frame.size.width, height: 45)
                    
                    installmentItemView.tag = index
                    installmentItemView.addGestureRecognizer(tap)
                
                    installmentItemView.installmentPriceLabel.text = String(format: "%.2f", installmentItem.getInstallmentTotalPrice()) + " \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
                    if installmentItem.getInstallmentNumber() > 1 {
                        installmentItemView.installmentOptionLabel.text = String("\(installmentItem.getInstallmentNumber()) \(NSLocalizedString("installment", bundle: .module, comment: "installment choice by number"))")
                    }

                    firstInstallmentView.installmentOptionsStackView.addArrangedSubview(installmentItemView)
                    
                    if firstInstallmentView.selected == installmentItemView.tag {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 1
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle.inset.filled")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
                    } else {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 0
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                    }
                }
                
                multipleCardsPaymentController!.installmentsEnabledFirstCard = true
            } else {
                firstInstallmentView.installmentOptionsStackView.arrangedSubviews.forEach { (view) in
                    let installmentItemView = view as! InstallmentOptionView
                    
                    if firstInstallmentView.selected == installmentItemView.tag {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 1
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle.inset.filled")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
                    } else {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 0
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                    }
                }
            }
        } else {
            multipleCardsPaymentController!.installmentsEnabledFirstCard = false
        }
        
        firstOptionsView.isHidden = !multipleCardsPaymentController!.isFirstCardValid
        firstOptionsView.threeDSSelected = multipleCardsPaymentController!.firstCardController.retrieveForce3DSChoiceOption()
        firstOptionsView.block3DSChoice = multipleCardsPaymentController!.firstCardController.retrieveForce3DSChoiceOption()
        
        if firstOptionsView.threeDSSelected {
            firstOptionsView.threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            firstOptionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            firstOptionsView.threeDSCheckImageView.image = UIImage(systemName: "square")
            firstOptionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
        
        // second card controller
        secondInstallmentView.isHidden = !multipleCardsPaymentController!.hasInstallmentSecondCard
        
        if multipleCardsPaymentController!.hasInstallmentSecondCard {
    
            if !multipleCardsPaymentController!.installmentsEnabledSecondCard {
                secondInstallmentView.installmentOptionsStackView.removeFullyAllArrangedSubviews()
                
                for (index, installmentItem) in multipleCardsPaymentController!.secondCardController.retrieveInstallments().first!.getInstallmentItems().enumerated() {
            
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSecond(_:)))
                    let installmentItemView = InstallmentOptionView()
                    installmentItemView.frame.size = CGSize(width: secondInstallmentView.frame.size.width, height: 45)
                    
                    installmentItemView.tag = index
                    installmentItemView.addGestureRecognizer(tap)
                
                    installmentItemView.installmentPriceLabel.text = String(format: "%.2f", installmentItem.getInstallmentTotalPrice()) + " \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
                    if installmentItem.getInstallmentNumber() > 1 {
                        installmentItemView.installmentOptionLabel.text = String("\(installmentItem.getInstallmentNumber()) \(NSLocalizedString("installment", bundle: .module, comment: "installment choice by number"))")
                    }

                    secondInstallmentView.installmentOptionsStackView.addArrangedSubview(installmentItemView)
                    
                    if secondInstallmentView.selected == installmentItemView.tag {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 1
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle.inset.filled")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
                    } else {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 0
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                    }
                }
                
                multipleCardsPaymentController!.installmentsEnabledSecondCard = true
            } else {
                secondInstallmentView.installmentOptionsStackView.arrangedSubviews.forEach { (view) in
                    let installmentItemView = view as! InstallmentOptionView
                    
                    if secondInstallmentView.selected == installmentItemView.tag {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 1
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle.inset.filled")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
                    } else {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 0
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                    }
                }
            }
        } else {
            multipleCardsPaymentController!.installmentsEnabledSecondCard = false
        }
        
        secondOptionsView.isHidden = !multipleCardsPaymentController!.isSecondCardValid
        secondOptionsView.threeDSSelected = multipleCardsPaymentController!.secondCardController.retrieveForce3DSChoiceOption()
        secondOptionsView.block3DSChoice = multipleCardsPaymentController!.secondCardController.retrieveForce3DSChoiceOption()
        
        if secondOptionsView.threeDSSelected {
            secondOptionsView.threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            secondOptionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            secondOptionsView.threeDSCheckImageView.image = UIImage(systemName: "square")
            secondOptionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
        
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("MultipleCardsPayment", owner: self, options: nil)
        
        multipleCardsPaymentController = MultipleCardsPaymentController(firstCardInformationView.cardController, and: secondCardInformationView.cardController)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
        self.firstAmountTextField.delegate = self
        self.secondAmountTextField.delegate = self
        
        firstCardAmountLabel.text = NSLocalizedString(
            "firstCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the first credit card"
        )
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
            )
        )
        
        secondCardAmountLabel.text = NSLocalizedString(
            "secondCardAmount",
            bundle: Bundle.module,
            comment: "amount of money to be paid from the second credit card"
        )
        
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
        
        makePaymentButton.layer.cornerRadius = 8
        makePaymentButton.setTitle(
            NSLocalizedString(
                "makePayment",
                bundle: Bundle.module,
                comment: "send payment request"
            ),
            for: .normal)
        
        firstInstallmentView.isHidden = !multipleCardsPaymentController!.hasInstallmentFirstCard
        
        firstOptionsView.isHidden = !multipleCardsPaymentController!.isFirstCardValid
        firstOptionsView.threeDSSelected = multipleCardsPaymentController!.firstCardController.retrieveForce3DSChoiceOption()
        
        secondInstallmentView.isHidden = !multipleCardsPaymentController!.hasInstallmentSecondCard
        
        secondOptionsView.isHidden = !multipleCardsPaymentController!.isSecondCardValid
        secondOptionsView.threeDSSelected = multipleCardsPaymentController!.secondCardController.retrieveForce3DSChoiceOption()
    }
    
    @objc func handleTapFirst(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            firstInstallmentView.selected = tag
        }
        
        layoutSubviews()
    }
    
    @objc func handleTapSecond(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            secondInstallmentView.selected = tag
        }
        
        layoutSubviews()
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
    
    @objc func moveNextTextField() {
        if firstAmountTextField.isFirstResponder {
            firstCardInformationView.cardNumberTextField.becomeFirstResponder()
        } else if firstCardInformationView.cardholderTextField.isFirstResponder {
            secondAmountTextField.becomeFirstResponder()
        } else if secondAmountTextField.isFirstResponder {
            secondCardInformationView.cardNumberTextField.becomeFirstResponder()
        } else if firstCardInformationView.cardNumberTextField.isFirstResponder {
            firstCardInformationView.expireDateTextField.becomeFirstResponder()
        } else if secondCardInformationView.cardNumberTextField.isFirstResponder {
            secondCardInformationView.expireDateTextField.becomeFirstResponder()
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
        } else if firstAmountTextField.isFirstResponder {
            firstAmountTextField.resignFirstResponder()
        }
    }
}
