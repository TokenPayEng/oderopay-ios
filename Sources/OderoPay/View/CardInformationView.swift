//
//  CardInformationView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit

class CardInformationView: UIView, UITextFieldDelegate {

    lazy private var cardAssociation: CardAssociation = .UNDEFINED
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardNumberTextField: UITextField! {
        didSet {
            cardNumberTextField.forLeftView(use: UIImage(systemName: "creditcard")!)
            cardNumberTextField.placeholder = NSLocalizedString("cardNumber",
                                                                bundle: Bundle.module,
                                                                comment: "card number")
            
            cardNumberTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
        }
    }
    
    @IBOutlet weak var expireDateTextField: UITextField! {
        didSet {
            expireDateTextField.forLeftView(use: UIImage(systemName: "calendar")!)
            expireDateTextField.placeholder = NSLocalizedString("mm/yy",
                                                               bundle: Bundle.module,
                                                               comment: "card expire month and year")
            
            expireDateTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
        }
    }
    
    @IBOutlet weak var cvcTextField: UITextField! {
        didSet {
            cvcTextField.forLeftView(use: UIImage(systemName: "lock")!)
            cvcTextField.placeholder = NSLocalizedString("cvc",
                                                         bundle: Bundle.module,
                                                         comment: "card cvc code")
            
            cvcTextField.addPreviousNextToolbar(
                onNext: (
                    target: self,
                    action: #selector(moveNextTextField)
                ),
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
        }
    }
    
    @IBOutlet weak var cardholderTextField: UITextField! {
        didSet {
            cardholderTextField.forLeftView(use: UIImage(systemName: "person")!)
            cardholderTextField.placeholder = NSLocalizedString("cardHolderNameSurname",
                                                                    bundle: Bundle.module,
                                                                    comment: "card holder's name and surname")
            
            cardholderTextField.addPreviousToolbar(
                onPrevious: (
                    target: self,
                    action: #selector(movePreviousTextField)
                )
            )
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
        Bundle.module.loadNibNamed("CardInformation", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.cardNumberTextField.delegate = self
        self.expireDateTextField.delegate = self
        self.cvcTextField.delegate = self
        self.cardholderTextField.delegate = self
    }
    
    // delegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchTextFieldForward(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // card number
        if textField == cardNumberTextField {
            guard let cardNumberInputCurrent = textField.text as? NSString else { return true }
            let cardNumberInputUpdated = cardNumberInputCurrent.replacingCharacters(in: range, with: string)
            
            if cardAssociation == .UNDEFINED {
                if var retrievedCardAssociation = CardInformationView.cardRepository.lookUpCardAssociation(Int(cardNumberInputUpdated) ?? 0) {
                    if retrievedCardAssociation == .VISA {
                        if CardInformationView.cardRepository.isVisaElectron(Int(cardNumberInputUpdated) ?? 0) {
                            retrievedCardAssociation = .VISA_ELECTRON
                        }
                    }
                    
                    cardAssociation = retrievedCardAssociation
                }
            } else {
                
                switch cardAssociation {
                case .VISA:
                    textField.setCardAssociation(use: UIImage(systemName: "visa")!)
                case .VISA_ELECTRON:
                    textField.setCardAssociation(use: UIImage(named: "visaelectron")!)
                case .MASTER_CARD:
                    textField.setCardAssociation(use: UIImage(named: "mastercard")!)
                case .MAESTRO:
                    textField.setCardAssociation(use: UIImage(named: "maestro")!)
                case .AMEX:
                    textField.setCardAssociation(use: UIImage(named: "amex")!)
                case .UNDEFINED:
                    print("card association undefined")
                }
            }
            
        }
        
        
        // ensure only 3 character long cvc field
        if  textField == cvcTextField {
            guard let cvcInputCurrent = textField.text as? NSString else { return true }
            let cvcInputUpdated = cvcInputCurrent.replacingCharacters(in: range, with: string)
            return cvcInputUpdated.count <= 3
        }
        
        return true
    }
    
    func switchTextFieldForward(_ textField: UITextField) {
        switch textField {
        case cardNumberTextField:
            expireDateTextField.becomeFirstResponder()
        case expireDateTextField:
            cvcTextField.becomeFirstResponder()
        case cvcTextField:
            cardholderTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
    }
    
    @objc func moveNextTextField() {
        if cardNumberTextField.isFirstResponder {
            expireDateTextField.becomeFirstResponder()
        } else if expireDateTextField.isFirstResponder {
            cvcTextField.becomeFirstResponder()
        } else if cvcTextField.isFirstResponder {
            cardholderTextField.becomeFirstResponder()
        }
    }
    
    @objc func movePreviousTextField() {
        
        if cardNumberTextField.isFirstResponder {
            cardNumberTextField.resignFirstResponder()
        } else if expireDateTextField.isFirstResponder {
            cardNumberTextField.becomeFirstResponder()
        } else if cvcTextField.isFirstResponder {
            expireDateTextField.becomeFirstResponder()
        } else if cardholderTextField.isFirstResponder {
            cvcTextField.becomeFirstResponder()
        }
    }
}

extension CardInformationView {
    static var cardRepository: CardRepository = CardRepository()
}

extension UITextField {
    func forLeftView(use image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = .systemGray3
        
        let uiView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        uiView.addSubview(imageView)
        
        leftView = uiView
        leftViewMode = .always
    }
    
    func setCardAssociation(use image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let uiView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        uiView.addSubview(imageView)
        
        rightView = uiView
        rightViewMode = .always
    }
    
    func addPreviousNextToolbar(onNext: (target: Any, action: Selector),
                                onPrevious: (target: Any, action: Selector)) {
        
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.items = [
            UIBarButtonItem(
                title: NSLocalizedString("previous", bundle: .module, comment: "go to previous text field"),
                style: .plain,
                target: onPrevious.target,
                action: onPrevious.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(
                title: NSLocalizedString("next", bundle: .module, comment: "go to next text field"),
                style: .done,
                target: onNext.target,
                action: onNext.action),
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    func addPreviousToolbar(onPrevious: (target: Any, action: Selector)) {
     
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.items = [
            UIBarButtonItem(
                title: NSLocalizedString("previous", bundle: .module, comment: "go to previous text field"),
                style: .plain,
                target: onPrevious.target,
                action: onPrevious.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    func addNextToolbar(onNext: (target: Any, action: Selector)) {
    
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(
                title: NSLocalizedString("next", bundle: .module, comment: "go to next text field"),
                style: .done,
                target: onNext.target,
                action: onNext.action),
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
}

