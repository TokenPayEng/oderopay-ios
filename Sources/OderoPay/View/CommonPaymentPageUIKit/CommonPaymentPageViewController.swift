//
//  CommonPaymentPage.swift
//  
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {
    
    public static let commonPaymentPageStoryboardVC = UIStoryboard(name: "CommonPaymentPage", bundle: .module).instantiateInitialViewController()!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let localizedString = NSLocalizedString("totalPrice", bundle: .module, comment: "comment")
        totalPriceLabel.text = localizedString
    }
}
