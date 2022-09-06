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
        Bundle.module.loadNibNamed("Installment", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        installmentChoiceView.layer.borderColor = UIColor(red: 108/255, green: 209/255, blue: 78/255, alpha: 1).cgColor
        installmentChoiceView.layer.cornerRadius = 4
        installmentOptionLabel.text = NSLocalizedString(
            "singlePayment",
            bundle: Bundle.module,
            comment: "installment number"
        )
    }
    
    @IBAction func installmentClicked(_ sender: UITapGestureRecognizer) {
        selected.toggle()
        
        if selected {
            installmentChoiceView.layer.borderWidth = 1
            checkImageView.image = UIImage(systemName: "circle.inset.filled")
            checkImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            installmentChoiceView.layer.borderWidth = 0
            checkImageView.image = UIImage(systemName: "circle")
            checkImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
}
