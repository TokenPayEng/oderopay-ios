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
    }
    
    @IBAction func initCommonPaymentPage(_ sender: Any) {
        print("Started process of initialization for Common Payment Page\n")
        print("retrieving unique keys...")
        
        if OderoPay.areKeysProvided() {
            print("unique keys retrieval ---- SUCCESS ✅")
            print("keys were found with following values \napi key = \(OderoPay.getKeys().0)\nsecret key = \(OderoPay.getKeys().1)\n")
            
            print("STEP #1 ---- (LOCAL)")
            print("checking for navigation controller...")
            
            guard let navigationController = navigationController else {
                print("no navigation controller found ---- FAIL ❌")
                print("HINT: navigation controller was not initialized for odero pay button, please use initNavigationController method")
                return
            }
            
            print("navigation controller check ---- SUCCESS ✅\n")
            
            print("STEP #2 ---- (LOCAL)")
            print("checking for checkout form...")
            
            if OderoPay.isCheckoutFormReady() {
                print("checkout form found ---- SUCCESS ✅\n")
                
                oderoPayButton.loadingIndicator(true)
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
                        
                        oderoPayButton.loadingIndicator(false)
                        
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

extension UIButton {
    struct ButtonState {
        var state: UIControl.State
        var title: String?
        var image: UIImage?
    }
    
    static private (set) var buttonStates: [ButtonState] = []
    
    func loadingIndicator(_ show: Bool) {
        let tag = 05_14_21
        if show {
            var buttonStates: [ButtonState] = []
            for state in [UIControl.State.disabled] {
                let buttonState = ButtonState(state: state, title: title(for: state), image: image(for: state))
                buttonStates.append(buttonState)
                setImage(UIImage(), for: state)
            }
            UIButton.buttonStates = buttonStates
            self.isEnabled = false
            self.alpha = 0.5
            self.setImage(nil, for: .normal)
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            for buttonState in UIButton.buttonStates {
                setTitle(buttonState.title, for: buttonState.state)
                setImage(buttonState.image, for: buttonState.state)
            }
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
