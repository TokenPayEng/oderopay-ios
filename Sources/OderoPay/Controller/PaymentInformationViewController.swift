//
//  PaymentInformationViewController.swift
//  
//
//  Created by Imran Hajiyev on 14.09.22.
//

import UIKit

class PaymentInformationViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        button.layer.cornerRadius = 4
        containerView.layer.cornerRadius = 16
        
        if OderoPay.isPaymentCompleted() {
            imageView.image = UIImage(named: "success", in: .module, with: .none)
            titleLabel.text = NSLocalizedString("paymentSuccess", bundle: .module, comment: "on successful payment")
            subtitleLabel.text = NSLocalizedString("returnToHome", bundle: .module, comment: "on successful payment")
            
            subtitleLabel2.isHidden = true
            button.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 3], animated: true)
            }
        } else {
            imageView.image = UIImage(named: "error", in: .module, with: .none)
            titleLabel.text = NSLocalizedString("paymentError", bundle: .module, comment: "on failure")
            subtitleLabel.text = NSLocalizedString("paymentErrorHelp", bundle: .module, comment: "on failure")
            subtitleLabel2.text = NSLocalizedString("paymentErrorHelp2", bundle: .module, comment: "on failure")
            button.setTitle(
                NSLocalizedString("returnToCheckout", bundle: .module, comment: "on failure").uppercased(),
                for: .normal
            )
        }
    }

    @IBAction func backToCheckout(_ sender: Any) {
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 3], animated: true)
    }
}
