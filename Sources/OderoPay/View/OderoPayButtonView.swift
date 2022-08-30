//
//  OderoPayButtonView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit
import WebKit

public class OderoPayButtonView: UIView, WKNavigationDelegate {
    
    var webView: WKWebView!
    var navigationController: UINavigationController?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var oderoPayImageView: UIImageView!
    @IBOutlet weak var oderoPayButton: UIButton! {
        didSet {
            oderoPayButton.layer.cornerRadius = 8
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // ---------------- public methods ------------------------
    
    public func initNavigationController(named navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func setOderoPayImageSize(height: CGFloat, width: CGFloat) {
        oderoPayImageView.constraints.first {$0.firstAnchor == oderoPayImageView.heightAnchor}?.isActive = false
        oderoPayImageView.constraints.first {$0.firstAnchor == oderoPayImageView.widthAnchor}?.isActive = false
        
        oderoPayImageView.updateConstraints()
        
        oderoPayImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        oderoPayImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func changeDefaultColor(fromWhiteToBlack value: Bool) {
        if value {
            oderoPayImageView.image = UIImage(named: "odero-pay-white", in: .module, compatibleWith: nil)
            oderoPayButton.tintColor = .black
            oderoPayButton.backgroundColor = .black
        } else {
            oderoPayImageView.image = UIImage(named: "odero-pay-black", in: .module, compatibleWith: nil)
            oderoPayButton.tintColor = .white
            oderoPayButton.backgroundColor = .white
        }
    }
    
    public func addOderoPayButtonOutline(colored color: UIColor) {
        oderoPayButton.layer.borderWidth = 1
        oderoPayButton.layer.borderColor = color.cgColor
    }
    
    public func removeOderoPayButtonOutline() {
        oderoPayButton.layer.borderWidth = 0
        oderoPayButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    // --------------------------------------------------------
    
    private func commonInit() {
        Bundle.module.loadNibNamed("OderoPayButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        webView = WKWebView()
        webView.navigationDelegate = self
        self.superview?.addSubview(webView)
    }
    
    @IBAction func initCommonPaymentPage(_ sender: Any) {
        print("Started process of initialization for Common Payment Page\n")
        print("retrieving unique keys...")
        
        if OderoPay.areKeysProvided() {
            print("unique keys retrieval ---- SUCCESS ✅")
            print("keys were found with following values \napi key = \(OderoPay.getKeys().0)\nsecret key = \(OderoPay.getKeys().1)\n")
            
            print("STEP #1 ---- (LOCAL)")
            print("checking for checkout form...")
            
            if OderoPay.isCheckoutFormReady() {
                print("checkout form found ---- SUCCESS ✅\n")
                
                print("STEP #2 ---- (NETWORK)")
                print("generating random key...")
                print("sending checkout form...")
                OderoPay.assignRandomKey(using: NSUUID().uuidString)
                Task {
                    do {
                        let checkoutFormResponse = try await OderoPay.sendCheckoutForm()
                        
                        if checkoutFormResponse.hasErrors() != nil {
                            print("checkout form returned with errors --- FAIL ❌")
                            print("Error code: \(String(describing: checkoutFormResponse.hasErrors()?.getErrorCode()))")
                            print("Error description: \(String(describing: checkoutFormResponse.hasErrors()?.getErrorDescription()))")
                            
                            return
                        }
                        
                        guard let resultFromServer = checkoutFormResponse.hasData() else {
                            print("Error occured ---- FAIL ❌")
                            print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")
                            return
                        }
                        
                        print("retrieving token...")
                        let token = resultFromServer.getToken()
                        print("token retrieved ---- SUCCESS ✅")
                        print(token)
                        print("checkout form sent ---- SUCCESS ✅\n")
                        OderoPay.assignRetrievedToken(withValue: token)
                        
                        print("STEP #3 ---- (LOCAL)")
                        print("retrieving displaying view settings...")
                        print("display settings retrieved ---- SUCCESS ✅")
                        if OderoPay.isAsWebView() {
                            print("displaying as Web View\n")
                            
                            print("retrieving web view url and creating request...")
                            let webViewURL = URL(string: resultFromServer.getWebViewURL())
                            let webViewRequest = URLRequest(url: webViewURL!)
                            print("webview url and request retrieved ---- SUCCESS ✅\n")
                            print("Navigating to the Common Payment Page ---- (WEB VIEW)")
                            webView.load(webViewRequest)
                        } else {
                            print("displaying as Native\n")
                            print("checking for navigation controller...")
                            
                            guard let navigationController = navigationController else {
                                print("no navigation controller found ---- FAIL ❌")
                                print("HINT: navigation controller was not initialized for odero pay button, please use initNavigationController method")
                                return
                            }
                            
                            print("navigation controller check ---- SUCCESS ✅\n")
                            print("Navigating to the Common Payment Page ---- (NATIVE)")
                            
                            let commonPaymentPageViewController = CommonPaymentPageViewController.getStoryboardViewController()
                            navigationController.pushViewController(commonPaymentPageViewController, animated: true)
                        }
                    } catch {
                        print("network error occured ---- FAIL ❌")
                        print("HINT: \(error)")
                    }
                }
            } else {
                print("checkout form is not provided by developer ---- FAIL ❌")
                print("HINT: checkout form should be initialized with correct values.")
                return
            }
        } else {
            print("no keys were provided by developer ---- FAIL ❌")
            return
        }
    }
}
