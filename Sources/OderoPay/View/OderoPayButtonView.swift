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
    @IBOutlet weak var oderoPayButton: UIButton! {
        didSet {
            oderoPayButton.layer.cornerRadius = 6
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
    
    public func setOderoPayButtonLabelSize(ofSize size: CGFloat) {
        oderoPayButton.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    public func setOderoPayButtonImageEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        oderoPayButton.imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    public func changeDefaultColor(fromWhiteToBlack value: Bool) {
        if value {
            oderoPayButton.tintColor = .black
            oderoPayButton.backgroundColor = .black
        } else {
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
        print("initializing common payment page")
        let commonPaymentPageViewController = CommonPaymentPageViewController.getStoryboardViewController()
        
        guard let navigationController = navigationController else {
            print("navigation controller was not initialized for odero pay button, please use initNavigationController method")
            return
        }

        navigationController.pushViewController(commonPaymentPageViewController, animated: true)
    }
}
