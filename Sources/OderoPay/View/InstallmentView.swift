//
//  InstallmentView.swift
//  
//
//  Created by Imran Hajiyev on 30.08.22.
//

import UIKit

class InstallmentView: UIView {

    internal var selected: Bool = false
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var installmentOptionLabel: UILabel!
    @IBOutlet weak var installmentPriceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("Installment", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        installmentOptionLabel.text = NSLocalizedString(
            "singlePayment",
            bundle: Bundle.module,
            comment: "installment number"
        )
    }
    
    @objc func installmentClicked() {
        selected.toggle()
        
        if selected {
            checkImageView.image = UIImage(systemName: "circle.inset.filled")
            checkImageView.tintColor = UIColor.init(red: 53, green: 211, blue: 47, alpha: 1)
        } else {
            checkImageView.image = UIImage(named: "circle")
            checkImageView.tintColor = UIColor.init(red: 225, green: 225, blue: 225, alpha: 1)
        }
        
    }
}
