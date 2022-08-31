//
//  InstallmentView.swift
//  
//
//  Created by Imran Hajiyev on 30.08.22.
//

import UIKit

class InstallmentView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var installmentOptionLabel: UILabel! {
        didSet {
            installmentOptionLabel.text = NSLocalizedString(
                "singlePayment",
                bundle: Bundle.module,
                comment: "installment number"
            )
        }
    }
    
    @IBOutlet weak var installmentPriceLabel: UILabel!
    
    private let userTap = UITapGestureRecognizer(target: InstallmentView.self, action: #selector(installmentClicked))
    internal var selected: Bool = false
    
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
    }
    
    @objc func installmentClicked() {
        
        if selected {
            checkImageView.image = UIImage(systemName: "circle.inset.filled")
            checkImageView.tintColor = UIColor.init(red: 53, green: 211, blue: 47, alpha: 1)
        } else {
            checkImageView.image = UIImage(named: "circle")
            checkImageView.tintColor = UIColor.init(red: 225, green: 225, blue: 225, alpha: 1)
        }
        
    }
}
