//
//  OptionsView.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import UIKit

class OptionsView: UIView {

    var threeDSSelected: Bool = false
    private var saveCardSelected: Bool = false
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.force3ds(notification:)), name: Notification.Name("3DSUpdate"), object: nil)

    }
    
    @objc func force3ds(notification: Notification) {
        threeDSSelected = notification.userInfo!["value"] as! Bool
        
        if threeDSSelected {
            threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            threeDSCheckImageView.image = UIImage(systemName: "square")
            threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
    
    @IBAction func threeDSClicked(_ sender: UITapGestureRecognizer) {
        threeDSSelected.toggle()
        
        if threeDSSelected {
            threeDSCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            threeDSCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            threeDSCheckImageView.image = UIImage(systemName: "square")
            threeDSCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
    
    @IBAction func saveCardClicked(_ sender: UITapGestureRecognizer) {
        saveCardSelected.toggle()
        
        if saveCardSelected {
            saveCardCheckImageView.image = UIImage(systemName: "checkmark.square.fill")
            saveCardCheckImageView.tintColor = UIColor.init(red: 53/255, green: 211/255, blue: 47/255, alpha: 1)
        } else {
            saveCardCheckImageView.image = UIImage(systemName: "square")
            saveCardCheckImageView.tintColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        }
    }
}
