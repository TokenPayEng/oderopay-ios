//
//  ThreeDSViewController.swift
//  
//
//  Created by Imran Hajiyev on 10.10.22.
//

import UIKit
import WebKit

class ThreeDSViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var htmlContent: String = String()
    var fromCardControllerType: CardControllers = .NOT_DEFINED
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString(htmlContent, baseURL: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.title = NSLocalizedString("3ds", bundle: .module,comment: "3ds verification")
        self.navigationController?.navigationBar.tintColor = .black
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            if String(describing: key).contains("success") {
                
                switch fromCardControllerType {
                case .SINGLE_CREDIT:
                    print("\nSingle Card 3DS Payment Success ✅\n")
                    OderoPay.setPaymentStatus(to: true)
                    presentResultScreens(forFirstMultiCard: false)
                case .MULTI_FIRST:
                    print("\nFirst Multiple Cards 3DS Payment Success ✅\n")
                    OderoPay.setMultipleCardsPaymentOneStatus(to: true)
                    NotificationCenter.default.post(name: Notification.Name("update2Height"), object: nil)
                    presentResultScreens(forFirstMultiCard: true)
                case .MULTI_SECOND:
                    print("\nSecond Multiple Cards 3DS Payment Success ✅\n")
                    OderoPay.setMultipleCardsPaymentTwoStatus(to: true)
                    OderoPay.setPaymentStatus(to: OderoPay.areMultipleCardsPaymentsCompleted().0 && OderoPay.areMultipleCardsPaymentsCompleted().1)
                    presentResultScreens(forFirstMultiCard: false)
                case .NOT_DEFINED:
                    return
                }
            }
            
            if String(describing: key).contains("failure") {
                
                switch fromCardControllerType {
                case .SINGLE_CREDIT:
                    print("\nSingle Card 3DS Payment Failure ❌\n")
                    OderoPay.setPaymentStatus(to: false)
                    presentResultScreens(forFirstMultiCard: false)
                case .MULTI_FIRST:
                    print("\nFirst Multiple Cards 3DS Payment Failure ❌\n")
                    OderoPay.setMultipleCardsPaymentOneStatus(to: false)
                    presentResultScreens(forFirstMultiCard: true)
                case .MULTI_SECOND:
                    print("\nSecond Multiple Cards 3DS Payment Failure ❌\n")
                    OderoPay.setMultipleCardsPaymentTwoStatus(to: false)
                    presentResultScreens(forFirstMultiCard: false)
                case .NOT_DEFINED:
                    return
                }
            }
        }
    }
    
    func presentResultScreens(forFirstMultiCard firstMulti: Bool) {
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
            
            paymentInformationViewController.comingFrom3DS = true
            paymentInformationViewController.isFirstMultiCard = firstMulti
            viewController = paymentInformationViewController
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
