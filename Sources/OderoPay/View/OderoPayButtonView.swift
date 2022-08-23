//
//  OderoPayButtonView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit

public class OderoPayButtonView: UIView {

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
    
    @IBAction func initCommonPaymentPage(_ sender: Any) async {
        print("started initialization of common payment page")
        print("step #1 (LOCAL)")
        print("checking for navigation controller...")
        
        let commonPaymentPageViewController = CommonPaymentPageViewController.getStoryboardViewController()
        
        guard let navigationController = navigationController else {
            print("navigation controller check - failure")
            print("navigation controller was not initialized for odero pay button, please use initNavigationController method")
            return
        }
        
        print("navigation controller check - success")
        print("LOCAL CHECK #1 - SUCCESS")
        
        print("step #2 (LOCAL)")
        print("checking for checkout form...")
        
        if OderoPay.isCheckoutFormReady() {
            print("checkout form check - success")
            print("LOCAL CHECK #2 - SUCCESS")
            print("step #3 (CONNECTION)")
            print("sending checkout form...")
            do {
                print("retrieving token...")
                // let token: String = try await OderoPay.sendCheckoutForm().getToken()
                // print(token)
                print("checkout form sending - success")
                print("CONNECTION CHECK #3 - SUCCESS")
                // guard let token = token else { return }
                navigationController.pushViewController(commonPaymentPageViewController, animated: true)
            } catch {
                print("sending checkout form - failure")
                print(error)
                print("CONNECTION CHECK #3 - FAILURE")
            }
        } else {
            print("checkout form check - failure")
            print("checkout form should be initialized with correct values.")
            print("LOCAL CHECK #2 - FAILURE")
        }
        
    }
}
