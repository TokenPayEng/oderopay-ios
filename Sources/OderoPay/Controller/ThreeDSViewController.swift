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
                    OderoPay.setPaymentStatus(to: true)
                case .MULTI_FIRST:
                    print("oh no 1")
                case .MULTI_SECOND:
                    print("oh no 2")
                case .NOT_DEFINED:
                    return
                }
                
                presentResultScreens()
            }
            
            if String(describing: key).contains("failure") {
                
                switch fromCardControllerType {
                case .SINGLE_CREDIT:
                    OderoPay.setPaymentStatus(to: false)
                case .MULTI_FIRST:
                    print("oh no 11")
                case .MULTI_SECOND:
                    print("oh no 22")
                case .NOT_DEFINED:
                    return
                }
                
                presentResultScreens()
            }
        }
    }
    
    func presentResultScreens() {
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
            viewController = paymentInformationViewController
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
