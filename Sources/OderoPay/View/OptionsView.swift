//
//  OptionsView.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import UIKit

class OptionsView: UIView {

    private var threeDSSelected: Bool = false
    private var saveCardSelected: Bool = false
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var threeDSChoiceStackView: UIStackView!
    @IBOutlet weak var threeDSCheckImageView: UIImageView!
    @IBOutlet weak var saveCardChoiceStackView: UIStackView!
    @IBOutlet weak var saveCardCheckImageView: UIImageView!
    
    @IBOutlet weak var threeDSLabel: UILabel! {
        didSet {
            threeDSLabel.text = NSLocalizedString("3dsPrompt", bundle: .module, comment: "Use 3DS Prompt")
        }
    }
    
    @IBOutlet weak var saveCardLabel: UILabel! {
        didSet {
            saveCardLabel.text = NSLocalizedString("saveCardPrompt", bundle: .module, comment: "Save Card Prompt")
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
        Bundle.module.loadNibNamed("Options", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func threeDSClicked(_ sender: UITapGestureRecognizer) {
        if threeDSSelected {
            threeDSCheckImageView.image = UIImage(systemName: "checkmark.square")
            threeDSCheckImageView.tintColor = UIColor.init(red: 53, green: 211, blue: 47, alpha: 1)
        } else {
            threeDSCheckImageView.image = UIImage(named: "square")
            threeDSCheckImageView.tintColor = UIColor.init(red: 225, green: 225, blue: 225, alpha: 1)
        }
    }
    
    @objc func saveCardClicked() {
        
        if saveCardSelected {
            saveCardCheckImageView.image = UIImage(systemName: "checkmark.square")
            saveCardCheckImageView.tintColor = UIColor.init(red: 53, green: 211, blue: 47, alpha: 1)
        } else {
            saveCardCheckImageView.image = UIImage(named: "square")
            saveCardCheckImageView.tintColor = UIColor.init(red: 225, green: 225, blue: 225, alpha: 1)
        }
    
    }
}
