//
//  OderoPayButtonView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit
import SafariServices

public class OderoPayButtonView: UIView, SFSafariViewControllerDelegate {
    
    var navigationController: UINavigationController?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var oderoPayImageView: UIImageView! {
        didSet {
            var logoImageName: String
            
            switch OderoPay.getEnvironment() {
            case .PROD_AZ:
                logoImageName = "odero-pay-black"
            case .PROD_TR:
                logoImageName = "odero-logo-tr"
            case .SANDBOX_AZ:
                logoImageName = "odero-pay-black"
            case .SANDBOX_TR:
                logoImageName = "odero-logo-tr"
            }
            
            oderoPayImageView.image = UIImage(named: logoImageName, in: .module, with: nil)
        }
    }
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
        if OderoPay.getEnvironment() == .PROD_AZ || OderoPay.getEnvironment() == .SANDBOX_AZ {
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
    }
    
    public func addOderoPayButtonOutline(colored color: UIColor) {
        oderoPayButton.layer.borderWidth = 1
        oderoPayButton.layer.borderColor = color.cgColor
    }
    
    public func removeOderoPayButtonOutline() {
        oderoPayButton.layer.borderWidth = 0
        oderoPayButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    func showLoadingIndicator(_ show: Bool) {
        let tag = 05_14_21
        if show {
            oderoPayImageView.image = nil
            oderoPayButton.isEnabled = false
            oderoPayButton.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = oderoPayButton.bounds.size.height
            let buttonWidth = oderoPayButton.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            oderoPayButton.addSubview(indicator)
            indicator.startAnimating()
        } else {
            oderoPayImageView.image = UIImage(named: "odero-pay-black", in: .module, with: .none)
            oderoPayButton.isEnabled = true
            oderoPayButton.alpha = 1.0
            if let indicator = oderoPayButton.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    // --------------------------------------------------------
    
    private func commonInit() {
        Bundle.module.loadNibNamed("OderoPayButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func initCommonPaymentPage(_ sender: Any) {
        print("\nStarted process of initialization for Common Payment Page\n")
        print("retrieving unique keys...")
        
        if OderoPay.areKeysProvided() {
            print("unique keys retrieval ---- SUCCESS ✅")
            print("keys were found with following values \napi key = \(OderoPay.getKeys().0)\nsecret key = \(OderoPay.getKeys().1)\n")
            
            print("STEP #1 ---- (LOCAL)")
            print("checking for navigation controller...")
            
            guard let navigationController = navigationController else {
                print("no navigation controller found ---- FAIL ❌")
                print("HINT: navigation controller was not initialized for odero pay button, please use initNavigationController method")
                
                showErrorAlert(ofType: .INTERNAL, .NOW)
                
                return
            }
            
            print("navigation controller check ---- SUCCESS ✅\n")
            
            print("STEP #2 ---- (LOCAL)")
            print("checking for checkout form...")
            
            if OderoPay.isCheckoutFormReady() {
                print("checkout form found ---- SUCCESS ✅\n")
                
                showLoadingIndicator(true)
                
                print("STEP #3 ---- (NETWORK)")
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

                            showErrorAlert(ofType: .MISSING_DATA, .NOW)

                            return
                        }

                        guard let resultFromServer = checkoutFormResponse.hasData() else {
                            print("Error occured ---- FAIL ❌")
                            print("HINT: check your http headers and keys. if everything is correct may be server error. please wait and try again.")

                            showErrorAlert(ofType: .SERVER, .LATER)

                            return
                        }

                        let token = resultFromServer.getToken()
                        print("token retrieved ---- SUCCESS ✅")
                        print(token)
                        print("checkout form sent ---- SUCCESS ✅\n")
                        OderoPay.assignRetrievedToken(withValue: token)

                        showLoadingIndicator(false)

                        print("STEP #4 ---- (LOCAL)")
                        print("retrieving displaying view settings...")
                        print("display settings retrieved ---- SUCCESS ✅")
                        if OderoPay.isAsWebView() {
                            print("displaying as Safari Web View\n")
                            print("retrieving web view url and creating safari view controller...")
                            let webViewURL = URL(string: resultFromServer.getWebViewURL())
                            let safariVC = SFSafariViewController(url: webViewURL!)
                            print("safari webview url and view controller created ---- SUCCESS ✅\n")

                            print("Navigating to the Common Payment Page ---- (WEB VIEW)")
                            navigationController.present(safariVC, animated: true)

                        } else {
                            print("displaying as Native\n")

                            print("Navigating to the Common Payment Page ---- (NATIVE)")
                            let commonPaymentPageViewController = CommonPaymentPageViewController.getStoryboardViewController()
                            navigationController.pushViewController(commonPaymentPageViewController, animated: true)
                        }
                    } catch {
                        print("network error occured ---- FAIL ❌")
                        print("HINT: \(error)")
                        showLoadingIndicator(false)

                        showErrorAlert(ofType: .NETWORK, .LATER)

                        return
                    }
                }
            } else {
                print("checkout form is not provided by developer ---- FAIL ❌")
                print("HINT: checkout form should be initialized with correct values.")
                showLoadingIndicator(false)
                
                showErrorAlert(ofType: .INTERNAL, .NOW)
                
                return
            }
        } else {
            print("no keys were provided by developer ---- FAIL ❌")
            showLoadingIndicator(false)
            
            showErrorAlert(ofType: .INTERNAL, .NOW)
            
            return
        }
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func showErrorAlert(ofType type: ErrorTypes, _ description: ErrorDescriptions) {
        let alert = UIAlertController(
            title: ErrorTypes.getLocalized(type),
            message: ErrorDescriptions.getLocalized(description),
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (_) in })
        )
        
        findViewController()?.present(alert, animated: true, completion: nil)
    }
}
