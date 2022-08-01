//
//  CommonPaymentPage.swift
//
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {
    
    // ---------------------UIViews----------------------
    @IBOutlet weak var creditOrDebitCardView: CreditOrDebitCardPayment!
    
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
    
    // ---------------------UIButtons---------------------
    @IBOutlet weak var creditCardOrDebitCardButton: UIButton! {
        didSet {
//            creditCardOrDebitCardButton.setImage(
//                UIImage(systemName: creditOrDebitCardView.isHidden
//                        ? "chevron.right" : "chevront.down"), for: .normal)
            creditCardOrDebitCardButton.setTitle(
                NSLocalizedString("creditCardOrDebitCard",
                                  bundle: Bundle.module,
                                  comment: "pay with credit card or debit card"),
                for: .normal)
        }
    }
    
    @IBOutlet weak var multipleCreditCardsButton: UIButton! {
        didSet {
            multipleCreditCardsButton.setTitle(
                NSLocalizedString("multipleCredit",
                                  bundle: Bundle.module,
                                  comment: "pay with credit card or debit card"),
                for: .normal)
        }
    }
    
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
    
    // ---------------------UIButton-Actions---------------------
    
    @IBAction func popViewController(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func collapseCreditOrDebitSection(_ sender: Any) {
        collapseSection(creditOrDebitCardView, using: creditCardOrDebitCardButton)
    }
    
    @IBAction func collapseMultipleCreditSection(_ sender: Any) {
        //collapseSection(creditOrDebitCardView, using: multipleCreditCardsButton)
    }
    
    private func collapseSection(_ section: UIView, using button: UIButton) {
        if section.isHidden {
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            section.isHidden = false
            
            section.constraints.first {$0.firstAnchor == section.heightAnchor}?.isActive = false
            section.updateConstraints()
            section.heightAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            section.isHidden = true
            
            section.constraints.first {$0.firstAnchor == section.heightAnchor}?.isActive = false
            section.updateConstraints()
            section.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
}

public extension UIViewController {
    static func getStoryboardViewController() -> UIViewController {
        let commonPaymentPageStoryboardViewController = UIStoryboard(name: "CommonPaymentPage", bundle: Bundle.module)
        
        return commonPaymentPageStoryboardViewController.instantiateInitialViewController()!
    }
}
