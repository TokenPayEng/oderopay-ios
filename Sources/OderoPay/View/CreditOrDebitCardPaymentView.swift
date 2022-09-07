//
//  CreditOrDebitCardPayemnt.swift
//  
//
//  Created by Imran Hajiyev on 01.08.22.
//

import UIKit

class CreditOrDebitCardPaymentView: UIView {
    
    var creditOrDebitCardPaymentController: CreditOrDebitCardPaymentController? = nil
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardInformationView: CardInformationView!
    @IBOutlet weak var installmentView: InstallmentView!
    @IBOutlet weak var optionsView: OptionsView!
    
    @IBOutlet weak var makePaymentButton: UIButton!
    
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

        installmentView.isHidden = !creditOrDebitCardPaymentController!.hasInstallment
        
        if creditOrDebitCardPaymentController!.hasInstallment {
    
            if !creditOrDebitCardPaymentController!.installmentsEnabled {
                installmentView.installmentOptionsStackView.removeFullyAllArrangedSubviews()
                
                for (index, installmentItem) in creditOrDebitCardPaymentController!.cardController.retrieveInstallments().first!.getInstallmentItems().enumerated() {
            
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    let installmentItemView = InstallmentOptionView()
                    installmentItemView.frame.size = CGSize(width: installmentView.frame.size.width, height: 45)
                    
                    installmentItemView.tag = index
                    installmentItemView.addGestureRecognizer(tap)
                
                    installmentItemView.installmentPriceLabel.text = String(format: "%.2f", installmentItem.getInstallmentTotalPrice()) + " \(OderoPay.getCheckoutForm().getCheckoutCurrencyRaw().currencySign)"
                    if installmentItem.getInstallmentNumber() > 1 {
                        installmentItemView.installmentOptionLabel.text = String("\(installmentItem.getInstallmentNumber()) \(NSLocalizedString("installment", bundle: .module, comment: "installment choice by number"))")
                    }

                    installmentView.installmentOptionsStackView.addArrangedSubview(installmentItemView)
                    
                    if installmentView.selected == installmentItemView.tag {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 1
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle.inset.filled")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
                    } else {
                        installmentItemView.installmentChoiceView.layer.borderWidth = 0
                        installmentItemView.checkImageView.image = UIImage(systemName: "circle")
                        installmentItemView.checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                    }
                }
                
                creditOrDebitCardPaymentController!.installmentsEnabled = true
            } else {
                installmentView.installmentOptionsStackView.arrangedSubviews.forEach { (view) in
                    let installmentItemView = view as! InstallmentOptionView
                    
                    if installmentView.selected == installmentItemView.tag {
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
            creditOrDebitCardPaymentController!.installmentsEnabled = false
        }
        
        optionsView.isHidden = !creditOrDebitCardPaymentController!.isCardValid
        optionsView.threeDSSelected = creditOrDebitCardPaymentController!.cardController.retrieveForce3DSChoiceOption()
        optionsView.block3DSChoice = creditOrDebitCardPaymentController!.cardController.retrieveForce3DSChoiceOption()

        if optionsView.threeDSSelected {
            optionsView.threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            optionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            optionsView.threeDSCheckImageView.image = UIImage(systemName: "square")
            optionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("CreditOrDebitCardPayment", owner: self, options: nil)
        
        creditOrDebitCardPaymentController = CreditOrDebitCardPaymentController(cardInformationView.cardController)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        installmentView.isHidden = !creditOrDebitCardPaymentController!.hasInstallment
        optionsView.isHidden = !creditOrDebitCardPaymentController!.isCardValid
        optionsView.threeDSSelected = creditOrDebitCardPaymentController!.cardController.retrieveForce3DSChoiceOption()
        
        makePaymentButton.layer.cornerRadius = 8
        makePaymentButton.setTitle(
            NSLocalizedString(
                "makePayment",
                bundle: Bundle.module,
                comment: "send payment request"
            ),
            for: .normal)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            installmentView.selected = tag
        }
        
        layoutSubviews()
    }
    
    @IBAction func makePayment(_ sender: Any) {
        let form = CompletePaymentForm(paymentType: .CARD_PAYMENT,
                            cardPrice: OderoPay.getCheckoutForm().getCheckoutPriceRaw(),
                            installment: .single,
                            card: Card(number: creditOrDebitCardPaymentController!.cardController.getUpdatedCardNumber(),
                                       expiringAt: .december,
                                       2023,
                                       withCode: 333,
                                       belongsTo: "Imran Hajiyev")
        )
        
        OderoPay.setCompletePaymentForm(to: form)
        Task {
            do {
                print(try await OderoPay.sendCompletePaymentForm())
            } catch {
                print(error)
            }
        }
    }
}

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
