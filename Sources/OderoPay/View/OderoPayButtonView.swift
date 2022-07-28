//
//  OderoPayButtonView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit

public class OderoPayButtonView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var oderoPayButton: UIButton! {
        didSet {
            oderoPayButton.layer.cornerRadius = 6
            
            oderoPayButton.setTitle(
                NSLocalizedString(
                    "payWithOdero",
                    bundle: Bundle.module,
                    comment: "pay with odero button"
                ),
                for: .normal)
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
    
    private func commonInit() {
        Bundle.module.loadNibNamed("OderoPayButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func initCommonPaymentPage(_ sender: Any) {
        print("initializing common payment page")
    }
}
