//
//  PointsView.swift
//  
//
//  Created by Imran Hajiyev on 19.10.22.
//

import UIKit

class PointsView: UIView {
    
    let pointsController: PointsController = PointsController()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var controllerButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var insideView: UIStackView!
    
    @IBOutlet weak var kamTitle: UILabel!
    @IBOutlet weak var ykbTitle: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var useAllLabel: UILabel!
    @IBOutlet weak var captionsLabel: UILabel!
    
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
        
        contentView.layer.cornerRadius = 4
        
        // translations
        controllerButton.setTitle(NSLocalizedString("cardPoints", bundle: .module, comment: "card points title"), for: .normal)
        
        kamTitle.text = NSLocalizedString("kamPoints", bundle: .module, comment: "koc ailem points")
        ykbTitle.text = NSLocalizedString("ykbPoints", bundle: .module, comment: "yapi kredi world points")
        
        totalPointsLabel.text = NSLocalizedString("totalPoints", bundle: .module, comment: "total points")
        useAllLabel.text = NSLocalizedString("useAll", bundle: .module, comment: "use all your points")
        captionsLabel.text = NSLocalizedString("kamCaption", bundle: .module, comment: "important captions")
        
        loadingIndicator.isHidden = true
        insideView.isHidden = true
        
        
    }
    
    @IBAction func toggleView(_ sender: Any) {
        if insideView.isHidden {
            pointsController.toggleContent(true)
            
            insideView.isHidden = false
            controllerButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            pointsController.toggleContent(false)
            
            insideView.isHidden = true
            controllerButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        }
        
        super.layoutIfNeeded()
        superview?.layoutIfNeeded()
    }
}
