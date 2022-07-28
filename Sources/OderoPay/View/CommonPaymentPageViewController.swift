//
//  CommonPaymentPage.swift
//
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {
    
    // ---------------------UILabels---------------------
    @IBOutlet weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.text = NSLocalizedString("totalPrice",
                                                     bundle: Bundle.module,
                                                     comment: "total price to be paid")
        }
    }
    
    @IBOutlet weak var paymentMethodLabel: UILabel! {
        didSet {
            paymentMethodLabel.text = NSLocalizedString("paymentMethod",
                                                        bundle: Bundle.module,
                                                        comment: "payment method for checkout")
        }
    }
    
    @IBOutlet weak var creditCardOrDebitCardLabel: UILabel! {
        didSet {
            creditCardOrDebitCardLabel.text = NSLocalizedString("creditCardOrDebitCard",
                                                                bundle: Bundle.module,
                                                                comment: "pay with credit card or debit card")
        }
        
    }
    
    @IBOutlet weak var multipleCreditCardsLabel: UILabel! {
        didSet {
            multipleCreditCardsLabel.text = NSLocalizedString("multipleCredit",
                                                              bundle: Bundle.module,
                                                              comment: "pay with credit card or debit card")
        }
    }
    
    // ---------------------UITextFields---------------------
    @IBOutlet weak var cardNumberTextField: UITextField! {
        didSet {
            cardNumberTextField.forLeftView(use: UIImage(systemName: "creditcard")!)
            cardNumberTextField.placeholder = NSLocalizedString("cardNumber",
                                                                bundle: Bundle.module,
                                                                comment: "card number")
        }
    }
    
    @IBOutlet weak var monthYearTextField: UITextField! {
        didSet {
            monthYearTextField.forLeftView(use: UIImage(systemName: "calendar")!)
            monthYearTextField.placeholder = NSLocalizedString("mm/yy",
                                                               bundle: Bundle.module,
                                                               comment: "card expire month and year")
        }
    }
    
    @IBOutlet weak var cvcTextField: UITextField! {
        didSet {
            cvcTextField.forLeftView(use: UIImage(systemName: "lock")!)
            cvcTextField.placeholder = NSLocalizedString("cvc",
                                                         bundle: Bundle.module,
                                                         comment: "card cvc code")
        }
    }
    
    @IBOutlet weak var cardholderNameTextField: UITextField! {
        didSet {
            cardholderNameTextField.forLeftView(use: UIImage(systemName: "person")!)
            cardholderNameTextField.placeholder = NSLocalizedString("cardHolderNameSurname",
                                                                    bundle: Bundle.module,
                                                                    comment: "card holder's name and surname")
        }
    }
    
    // ---------------------UIButtons---------------------
    @IBOutlet weak var confirmPaymentButton: UIButton! {
        didSet {
            confirmPaymentButton.layer.cornerRadius = 6
            confirmPaymentButton.setTitle(
                NSLocalizedString("makePayment",
                                  bundle: Bundle.module,
                                  comment: "make payment with chosen payment method"),
                for: .normal)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

public extension UIViewController {
    
    static func getStoryboardViewController() -> UIViewController {
        let commonPaymentPageStoryboardViewController = UIStoryboard(name: "CommonPaymentPage", bundle: Bundle.module)
        
        return commonPaymentPageStoryboardViewController.instantiateInitialViewController()!
    }
}

extension UITextField {
    func forLeftView(use image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = .systemGray3
        
        let uiView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        uiView.addSubview(imageView)
        
        leftView = uiView
        leftViewMode = .always
    }
}
