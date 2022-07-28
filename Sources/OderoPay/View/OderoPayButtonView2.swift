//
//  OderoPayButtonView2.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit

class OderoPayButtonView2: UIButton {


    @IBOutlet var asd: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("OderoPayButton2", owner: self, options: nil)
        asd.frame = self.bounds
        asd.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
