//
//  OderoAlertView.swift
//  
//
//  Created by Imran Hajiyev on 08.09.22.
//

import UIKit

class OderoAlertView: UIView {
    
    var controller = OderoAlertController()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("OderoAlert", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.backgroundColor = controller.getColor()
        alertImageView.image = UIImage(systemName: controller.getImageName())
        alertLabel.text = controller.getMessage()
    }
}
