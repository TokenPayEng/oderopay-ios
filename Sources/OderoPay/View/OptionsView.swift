//
//  OptionsView.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import UIKit

class OptionsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var threeDSChoiceStackView: UIStackView!
    @IBOutlet weak var threeDSCheckImageView: UIImageView!
    @IBOutlet weak var saveCardChoiceStackView: UIStackView!
    @IBOutlet weak var saveCardCheckImageView: UIImageView!
    
    @IBOutlet weak var threeDSLabel: UILabel!
    @IBOutlet weak var saveCardLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("Options", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        threeDSLabel.text = NSLocalizedString("3dsPrompt", bundle: .module, comment: "Use 3DS Prompt")
        saveCardLabel.text = NSLocalizedString("saveCardPrompt", bundle: .module, comment: "Save Card Prompt")

    }
}
