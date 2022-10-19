//
//  PointsView.swift
//  
//
//  Created by Imran Hajiyev on 19.10.22.
//

import UIKit

class PointsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var controllerButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var insideView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("Points", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.isHidden = !OderoPay.isPayByPointsEnabled()
        
        loadingIndicator.isHidden = true
        insideView.isHidden = true
    }
    
    @IBAction func toggleView(_ sender: Any) {
        insideView.isHidden = insideView.isHidden ? false : true;
        controllerButton.imageView?.image =  insideView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.right")
    }
}
