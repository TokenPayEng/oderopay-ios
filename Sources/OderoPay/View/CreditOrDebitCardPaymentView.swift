//
//  CreditOrDebitCardPayemnt.swift
//  
//
//  Created by Imran Hajiyev on 01.08.22.
//

import UIKit

class CreditOrDebitCardPaymentView: UIView {
    
    var creditOrDebitCardPaymentController: CreditOrDebitCardPaymentController? = nil
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardInformationView: CardInformationView!
    
    @IBOutlet weak var optionsView: OptionsView!
    @IBOutlet weak var makePaymentButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        optionsView.isHidden = !creditOrDebitCardPaymentController!.isCardValid
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("CreditOrDebitCardPayment", owner: self, options: nil)
        
        creditOrDebitCardPaymentController = CreditOrDebitCardPaymentController(cardInformationView.cardController)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        optionsView.isHidden = !creditOrDebitCardPaymentController!.isCardValid
        
        makePaymentButton.layer.cornerRadius = 8
        makePaymentButton.setTitle(
            NSLocalizedString(
                "makePayment",
                bundle: Bundle.module,
                comment: "send payment request"
            ),
            for: .normal)
    }
}
