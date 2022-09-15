//
//  InstallmentOptionView.swift
//  
//
//  Created by Imran Hajiyev on 06.09.22.
//

import UIKit

class InstallmentOptionView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var installmentChoiceView: UIStackView!
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
        Bundle.module.loadNibNamed("InstallmentOption", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        installmentOptionLabel.text = NSLocalizedString("singlePayment", bundle: .module, comment: "single installment")

        installmentChoiceView.layer.borderColor = UIColor(red: 108/255, green: 209/255, blue: 78/255, alpha: 1).cgColor
        installmentChoiceView.layer.cornerRadius = 4
    }
}
