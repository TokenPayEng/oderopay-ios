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
        if let key = change?[NSKeyValueChangeKey.newKey] as? String {
            
            print("\nobserveValue: \(key)\n")
            
            if key.contains("success") {
                OderoPay.setPaymentStatus(to: true)
                presentResultScreens()
            }
            
            if key.contains("error") {
                OderoPay.setPaymentStatus(to: false)
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
            
            viewController = paymentInformationViewController
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
