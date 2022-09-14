//
//  CommonPaymentPage.swift
//
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {

    var creditOrDebitCardPaymentController: CreditOrDebitCardPaymentController {
        creditOrDebitCardView.creditOrDebitCardPaymentController!
    }
    var multipleCardsPaymentController: MultipleCardsPaymentController {
        multipleCardsView.multipleCardsPaymentController!
    }
    
    var multipleCardsPaymentViewHeight: CGFloat {
        multipleCardsPaymentController.height
    }
    
    // ---------------------CreditOrDebitCardPayment----------------------
    @IBOutlet weak var creditOrDebitCardView: CreditOrDebitCardPaymentView! {
        didSet {
            creditOrDebitCardView.isHidden = !creditOrDebitCardPaymentController.isformEnabled
        }
    }
    @IBOutlet weak var creditOrDebitCardViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            creditOrDebitCardViewHeightConstraint.constant = creditOrDebitCardPaymentController.height
        }
    }
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeights), name: NSNotification.Name(rawValue: "updateHeights"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(update2Height), name: NSNotification.Name(rawValue: "update2Height"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callPaymentInformation), name: NSNotification.Name(rawValue: "callPaymentInformation"), object: nil)
        
        creditCardOrDebitCardButton.setImage(creditOrDebitCardPaymentController.image, for: .normal)
    }
    
    @objc func updateHeights() {
        creditOrDebitCardViewHeightConstraint.constant = creditOrDebitCardPaymentController.height
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func collapseCreditOrDebitSection(_ sender: Any) {
        creditOrDebitCardView.creditOrDebitCardPaymentController!.isformEnabled.toggle()
        collapseSection(creditOrDebitCardView, ofHeight: creditOrDebitCardPaymentController.height, using: creditCardOrDebitCardButton, and: creditOrDebitCardViewHeightConstraint)
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
        let paymentInformationViewController = PaymentInformationViewController()
        let navigation = UINavigationController(rootViewController: paymentInformationViewController)
        
        navigation.modalPresentationStyle = .pageSheet
        
//        if let sheet = navigation.sheetPresentationController {
//            sheet.detents = [.medium()]
//        }
        
        present(paymentInformationViewController,animated: true, completion: nil)
    }
}

extension UIViewController {
    static func getStoryboardViewController() -> UIViewController {
        let commonPaymentPageStoryboardViewController = UIStoryboard(name: "CommonPaymentPage", bundle: Bundle.module)
        
        return commonPaymentPageStoryboardViewController.instantiateInitialViewController()!
    }
}
