//
//  CommonPaymentPage.swift
//  
//
//  Created by Imran Hajiyev on 26.07.22.
//

import Foundation
import UIKit

public class CommonPaymentPageViewController: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let localizedString = NSLocalizedString("totalPrice", bundle: .module)
        totalPriceLabel.text = localizedString
    }
}
