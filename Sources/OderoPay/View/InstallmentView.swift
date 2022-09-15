//
//  InstallmentView.swift
//  
//
//  Created by Imran Hajiyev on 30.08.22.
//

import UIKit

class InstallmentView: UIView {
    
    var selected: Int = 1
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var installmentOptionsStackView: UIStackView!
    
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
        
        choiceLabel.text = NSLocalizedString("installmentChoices", bundle: .module, comment: "choices for installments")
    }
}
