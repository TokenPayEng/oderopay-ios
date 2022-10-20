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
    @IBOutlet weak var pointsView: PointsView!
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

        if OderoPay.getEnvironment() == .SANDBOX_TR || OderoPay.getEnvironment() == .PROD_TR {
            if creditOrDebitCardPaymentController!.isCardValid && creditOrDebitCardPaymentController!.cardController.isExpireValid() {
                pointsView.isHidden = !creditOrDebitCardPaymentController!.hasPayByPoints
            }
        }
    
        installmentView.isHidden = !creditOrDebitCardPaymentController!.hasInstallment
        
        if creditOrDebitCardPaymentController!.hasInstallment {
    
            if !creditOrDebitCardPaymentController!.installmentsEnabled {
                installmentView.installmentOptionsStackView.removeFullyAllArrangedSubviews()
                
                for installmentItem in creditOrDebitCardPaymentController!.cardController.retrieveInstallment()!.getInstallmentItems() {
            
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    let installmentItemView = InstallmentOptionView()
                    installmentItemView.frame.size = CGSize(width: installmentView.frame.size.width, height: 45)
                    
                    installmentItemView.tag = installmentItem.getInstallmentNumber()
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
        
        if creditOrDebitCardPaymentController!.cardController.retrieveBlock3DSChoiceOption() {
            optionsView.threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            optionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            if creditOrDebitCardPaymentController!.cardController.retrieveForce3DSChoiceOption() {
                optionsView.threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
                optionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
            } else {
                optionsView.threeDSCheckImageView.image = UIImage(systemName: "square")
                optionsView.threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
            }
        }
        
        if creditOrDebitCardPaymentController!.cardController.retrieveSaveCardChoiceOption() {
            optionsView.saveCardCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            optionsView.saveCardCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            optionsView.saveCardCheckImageView.image = UIImage(systemName: "square")
            optionsView.saveCardCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("CreditOrDebitCardPayment", owner: self, options: nil)
        
        if OderoPay.getEnvironment() == .SANDBOX_TR || OderoPay.getEnvironment() == .PROD_TR {
            creditOrDebitCardPaymentController = CreditOrDebitCardPaymentController(cardInformationView.cardController, with: pointsView.pointsController)
            pointsView.isHidden = true
        } else {
            creditOrDebitCardPaymentController = CreditOrDebitCardPaymentController(cardInformationView.cardController)
            pointsView.removeFromSuperview()
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        installmentView.isHidden = !creditOrDebitCardPaymentController!.hasInstallment
        optionsView.isHidden = !creditOrDebitCardPaymentController!.isCardValid
        
        let tapSave = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSave(_:)))
        let tap3DS = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3DS(_:)))
        optionsView.saveCardChoiceStackView.addGestureRecognizer(tapSave)
        optionsView.threeDSChoiceStackView.addGestureRecognizer(tap3DS)
        
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
            let item = creditOrDebitCardPaymentController!.cardController.retrieveInstallment()!.getInstallmentItems().first(where: {$0.getInstallmentNumber() == tag})
            
            creditOrDebitCardPaymentController!.cardController.setInstallmentChoice(tag, is: item!.getInstallmentTotalPrice())
            print(tag)
        }
        
        layoutSubviews()
    }
    
    @objc func handleTapSave(_ sender: UITapGestureRecognizer) {
        creditOrDebitCardPaymentController!.cardController.toggleSaveCardChoiceOption()
        
        layoutSubviews()
    }
    
    @objc func handleTap3DS(_ sender: UITapGestureRecognizer) {
        creditOrDebitCardPaymentController!.cardController.toggleForce3DSChoiceOption()
        
        layoutSubviews()
    }
    
    @IBAction func makePayment(_ sender: Any) {

        if creditOrDebitCardPaymentController!.cardController.isCardInfoValid() {
            creditOrDebitCardPaymentController!.isPaymentComplete = true
            NotificationCenter.default.post(name: Notification.Name("completePayment"), object: nil)
        } else {
            showErrorAlert(ofType: .MISSING_DATA, .CARD)
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
