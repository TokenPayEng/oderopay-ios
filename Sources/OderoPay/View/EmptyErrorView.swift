//
//  EmptyErrorView.swift
//  
//
//  Created by Imran Hajiyev on 10.10.22.
//

import UIKit

class EmptyErrorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
        messageLabel.text = NSLocalizedString("oops", bundle: .module, comment: "oh no")
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("EmptyError", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
