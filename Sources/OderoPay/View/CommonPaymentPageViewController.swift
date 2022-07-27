//
//  CommonPaymentPage.swift
//
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {
    
    // UILabels
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var creditCardOrDebitCardLabel: UILabel!
    @IBOutlet weak var multipleCreditCardsLabel: UILabel!
    
    // UITextFields
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var monthYearTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var cardholderNameTextField: UITextField!
    
    // UIButtons
    @IBOutlet weak var confirmPaymentButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------LOCALIZATIONS-----------------
        
        // setting up label text localizations
        totalPriceLabel.text = NSLocalizedString("totalPrice",
                                                 bundle: Bundle.module,
                                                 comment: "total price to be paid")
        
        paymentMethodLabel.text = NSLocalizedString("paymentMethod",
                                                    bundle: Bundle.module,
                                                    comment: "payment method for checkout")
        
        creditCardOrDebitCardLabel.text = NSLocalizedString("creditCardOrDebitCard",
                                                            bundle: Bundle.module,
                                                            comment: "pay with credit card or debit card")
        
        multipleCreditCardsLabel.text = NSLocalizedString("multipleCredit",
                                                          bundle: Bundle.module,
                                                          comment: "pay with credit card or debit card")
        
        // setting up textfield placeholder localizations
        cardNumberTextField.placeholder = NSLocalizedString("cardNumber",
                                                            bundle: Bundle.module,
                                                            comment: "card number")
        
        monthYearTextField.placeholder = NSLocalizedString("mm/yy",
                                                           bundle: Bundle.module,
                                                           comment: "card expire month and year")
        
        cvcTextField.placeholder = NSLocalizedString("cvc",
                                                     bundle: Bundle.module,
                                                     comment: "card cvc code")
        
        cardholderNameTextField.placeholder = NSLocalizedString("cardHolderNameSurname",
                                                                bundle: Bundle.module,
                                                                comment: "card holder's name and surname")
        
        // setting up button text localizations
        confirmPaymentButton.setTitle(
            NSLocalizedString("makePayment",
                              bundle: Bundle.module,
                              comment: "make payment with chosen payment method"),
            for: .normal)
        
        // -----------------UI CHANGES-----------------
        
        // credit or debit card number
        let cardNumberLeftView = UIImageView()
        let cardImage = UIImage(systemName: "creditcard")
        cardNumberLeftView.image = cardImage
        cardNumberTextField.leftView = cardNumberLeftView
        cardNumberTextField.leftViewMode = .always
        
        // card expire month year
        let expireDateLeftYear = UIImageView()
        let calendarImage = UIImage(systemName: "calendar")
        expireDateLeftYear.image = calendarImage
        monthYearTextField.leftView = expireDateLeftYear
        monthYearTextField.leftViewMode = .always
        
        // card secure code
        let cvcCodeLeftView = UIImageView()
        let lockImage = UIImage(systemName: "lock")
        cvcCodeLeftView.image = lockImage
        cvcTextField.leftView = cvcCodeLeftView
        cvcTextField.leftViewMode = .always
        
        // card holder name surname
        let cardHolderNameLeftView = UIImageView()
        let personImage = UIImage(systemName: "person")
        cardHolderNameLeftView.image = personImage
        cardholderNameTextField.leftView = cardHolderNameLeftView
        cardholderNameTextField.leftViewMode = .always
    }
    
}

public extension UIViewController {
    
    static func getStoryboardViewController() -> UIViewController {
        let commonPaymentPageStoryboardViewController = UIStoryboard(name: "CommonPaymentPage", bundle: Bundle.module)
        
        return commonPaymentPageStoryboardViewController.instantiateInitialViewController()!
    }
}
