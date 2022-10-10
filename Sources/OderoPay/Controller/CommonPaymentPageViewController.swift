//
//  CommonPaymentPage.swift
//
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {

    var singleCardPaymentController: SingleCardPaymentController {
        singleCardView.singleCardPaymentController!
    }
    var multipleCardsPaymentController: MultipleCardsPaymentController {
        multipleCardsView.multipleCardsPaymentController!
    }
    
    var multipleCardsPaymentViewHeight: CGFloat {
        multipleCardsPaymentController.height
    }
    
    // ---------------------CreditOrDebitCardPayment----------------------
    
    @IBOutlet weak var singleCardView: SingleCardPaymentView! {
        didSet {
            singleCardView.isHidden = !singleCardPaymentController.isformEnabled
        }
    }
    @IBOutlet weak var singleCardViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            singleCardViewHeightConstraint.constant = singleCardPaymentController.height
        }
    }
    
    // ---------------------Vertical Divider-------------------------
    
    @IBOutlet weak var singleAndMultipleDivider: UIView!
    
    // ---------------------MultipleCardPayment----------------------
    @IBOutlet weak var multipleCardsView: MultipleCardsPaymentView! {
        didSet {
            multipleCardsView.isHidden = !multipleCardsPaymentController.isformEnabled
        }
    }
    @IBOutlet weak var multipleCardsViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            multipleCardsViewHeightConstraint.constant = multipleCardsPaymentViewHeight
        }
    }
    
    // ---------------------UILabels---------------------
    @IBOutlet weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.text = NSLocalizedString("totalPrice",
                                                     bundle: Bundle.module,
                                                     comment: "total price to be paid")
        }
    }
    
    @IBOutlet weak var totalPriceValueLabel: UILabel! {
        didSet {
            totalPriceValueLabel.text = OderoPay.getCheckoutForm().getCheckoutPrice()
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
            
            multipleCreditCardsButton.setImage(multipleCardsPaymentController.image, for: .normal)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        var logoImageName: String
        
        switch OderoPay.getEnvironment() {
        case .PROD_AZ:
            logoImageName = "odero-logo"
        case .PROD_TR:
            logoImageName = "odero-logo-tr"
        case .SANDBOX_AZ:
            logoImageName = "odero-logo"
        case .SANDBOX_TR:
            logoImageName = "odero-logo-tr"
        }
        
        logoImageView.image = UIImage(named: logoImageName, in: .module, with: nil)
        
        Task {
            do {
                creditCardOrDebitCardButton.isHidden = try await !OderoPay.isSingleCardPaymentEnabled()
//                multipleCreditCardsButton.isHidden = try await !OderoPay.isMultipleCardsPaymentEnabled()
//                singleAndMultipleDivider.isHidden = try await !OderoPay.isSingleCardPaymentEnabled() || try await !OderoPay.isMultipleCardsPaymentEnabled()
            } catch {
                print("network error occured (merchant settings) ---- FAIL ❌")
                print("HINT: \(error)")
                return
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeights), name: NSNotification.Name(rawValue: "updateHeights"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(update2Height), name: NSNotification.Name(rawValue: "update2Height"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callPaymentInformation), name: NSNotification.Name(rawValue: "callPaymentInformation"), object: nil)
        
        creditCardOrDebitCardButton.setImage(singleCardPaymentController.image, for: .normal)
    }
    
    @objc func updateHeights() {
        singleCardViewHeightConstraint.constant = singleCardPaymentController.height
        multipleCardsViewHeightConstraint.constant = multipleCardsPaymentController.height
    }
    
    @objc func update2Height() {
        multipleCardsViewHeightConstraint.constant = multipleCardsPaymentController.height
    }
    
    @objc func callPaymentInformation() {
        presentPaymentInfo()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateHeights"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "update2Height"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "callPaymentInformation"), object: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // ---------------------UIButton-Actions---------------------
    
    @IBAction func popViewController(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func collapseCreditOrDebitSection(_ sender: Any) {
        singleCardView.singleCardPaymentController!.isformEnabled.toggle()
        collapseSection(singleCardView, ofHeight: singleCardPaymentController.height, using: creditCardOrDebitCardButton, and: singleCardViewHeightConstraint)
    }
    
    @IBAction func collapseMultipleCreditSection(_ sender: Any) {
        multipleCardsPaymentController.isformEnabled.toggle()
        collapseSection(multipleCardsView, ofHeight: multipleCardsPaymentController.height, using: multipleCreditCardsButton, and: multipleCardsViewHeightConstraint)
    }
    
    private func collapseSection(_ section: UIView, ofHeight height: CGFloat, using button: UIButton, and heightConstraint: NSLayoutConstraint) {
        if section.isHidden {
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            heightConstraint.constant = height
            section.isHidden = false
        } else {
            button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            heightConstraint.constant = 0
            section.isHidden = true
        }
        
        section.layoutIfNeeded()
    }
    
    private func presentPaymentInfo() {
        var viewController: UIViewController = UIViewController()
        
        if OderoPay.shouldUseCustomEndScreens() {
            viewController = OderoPay.isPaymentCompleted() ? OderoPay.getCustomSuccessScreenViewController() : OderoPay.getCustomErrorScreenViewController()
        } else {
            guard let paymentInformationViewController = UIStoryboard(
                name: "PaymentInformation",
                bundle: .module).instantiateViewController(identifier: "PaymentInformation") as? PaymentInformationViewController
            else {
                fatalError("Unable to instantiate Payment Information")
            }
            
            viewController = paymentInformationViewController
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    static func getStoryboardViewController() -> UIViewController {
        let commonPaymentPageStoryboardViewController = UIStoryboard(name: "CommonPaymentPage", bundle: Bundle.module)
        
        return commonPaymentPageStoryboardViewController.instantiateInitialViewController()!
    }
}
