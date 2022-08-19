//
//  CardInformationView.swift
//  
//
//  Created by Imran Hajiyev on 28.07.22.
//

import UIKit

class CardInformationView: UIView, UITextFieldDelegate {

    lazy private var cardAssociation: CardAssociation = .UNDEFINED
    lazy private var cardIinRangeString: String = String()
    
    lazy private var cardNumberPattern: String = "#### ##"
    
    lazy private var expireMonth: Int8 = Int8()
    lazy private var expireYear: Int8 = Int8()
    lazy private var expireDatePattern: String = "##/##"
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.green.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // card number
        if textField == cardNumberTextField {
            guard let cardNumberInputCurrent = textField.text as? NSString else { return false }
            let cardNumberInputUpdated = cardNumberInputCurrent
                .replacingCharacters(in: range, with: string)
                .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            // initial check
            if cardAssociation == .UNDEFINED {
                cardAssociation = CardInformationView.cardRepository.lookUpCardAssociation(Int(cardNumberInputUpdated) ?? 0)
                cardIinRangeString = cardNumberInputUpdated
            }
            
            // setting iin range as undefined if pattern changes
            cardAssociation = cardNumberInputUpdated.count == 0 ? .UNDEFINED : cardAssociation
            cardAssociation = cardIinRangeString.count > cardNumberInputUpdated.count && cardAssociation == .VISA_ELECTRON ? .VISA : cardIinRangeString.count > cardNumberInputUpdated.count ? .UNDEFINED : cardAssociation
            
            // by associtation
            switch cardAssociation {
            case .VISA:
                if !UITextField.cardAssociationSet {
                    textField.setCardAssociation(
                        use: UIImage(named: "visa", in: .module, with: .none)!
                    )
                } else {
                    if CardInformationView.cardRepository.isVisaElectron(Int(cardNumberInputUpdated) ?? 0) {
                        cardAssociation = .VISA_ELECTRON
                        cardIinRangeString = cardNumberInputUpdated
                        textField.setCardAssociation(
                            use: UIImage(named: "visaelectron", in: .module, with: .none)!
                        )
                        
                        textField.text = formatBy(pattern: VisaElectron.pattern.first!, this: cardNumberInputUpdated)
                        return false
                    } else {
                        cardIinRangeString = String(Visa.iinRanges.first!)
                        textField.setCardAssociation(
                            use: UIImage(named: "visa", in: .module, with: .none)!
                        )
                        
                        if cardNumberInputUpdated.count < 13 {
                            textField.text = formatBy(pattern: Visa.pattern.first!, this: cardNumberInputUpdated)
                        } else if cardNumberInputUpdated.count > 19 {
                            return false
                        } else {
                            textField.text = formatBy(pattern: Visa.patternByLength[cardNumberInputUpdated.count]!, this: cardNumberInputUpdated)
                        }
                        return false
                    }
                }
            case .VISA_ELECTRON:
                if !UITextField.cardAssociationSet {
                    textField.setCardAssociation(
                        use: UIImage(named: "visaelectron", in: .module, with: .none)!
                    )
                }
                
                textField.text = formatBy(pattern: VisaElectron.pattern.first!, this: cardNumberInputUpdated)
                return false
            case .MASTER_CARD:
                if !UITextField.cardAssociationSet {
                    textField.setCardAssociation(
                        use: UIImage(named: "mastercard", in: .module, with: .none)!
                    )
                }
                
                textField.text = formatBy(pattern: MasterCard.pattern.first!, this: cardNumberInputUpdated)
                return false
            case .MAESTRO:
                if !UITextField.cardAssociationSet {
                    textField.setCardAssociation(
                        use: UIImage(named: "maestro", in: .module, with: .none)!
                    )
                }
                            
                if cardNumberInputUpdated.count < 12 {
                    textField.text = formatBy(pattern: Maestro.pattern.first!, this: cardNumberInputUpdated)
                } else if cardNumberInputUpdated.count > 19 {
                    return false
                } else {
                    textField.text = formatBy(pattern: Maestro.patternByLength[cardNumberInputUpdated.count]!, this: cardNumberInputUpdated)
                }
                return false
            case .AMEX:
                if !UITextField.cardAssociationSet {
                    textField.setCardAssociation(
                        use: UIImage(named: "amex", in: .module, with: .none)!
                    )
                }
                
                textField.text = formatBy(pattern: AmericanExpress.pattern.first!, this: cardNumberInputUpdated)
                return false
            case .UNDEFINED:
                if UITextField.cardAssociationSet {
                    textField.removeCardAssociation()
                }
                
                textField.text = formatBy(pattern: cardNumberPattern, this: cardNumberInputUpdated)
                return false
            }
        }
        
        // create masking as MM/YY
        // ensured only to have 5 character long field by masking
        // check for MM < 12 and MM/YY > current month year
        if textField == expireDateTextField {
            guard let expireDateInputCurrent = textField.text as? NSString else { return false }
            let expireDateInputUpdated = expireDateInputCurrent.replacingCharacters(in: range, with: string)
            
            textField.text = formatBy(pattern: expireDatePattern, this: expireDateInputUpdated)
            
            if expireDateInputUpdated.count == 2 {
                
            }
            
//            if textField.text!.contains("/") {
//                let expireDateFields = textField.text!.split(separator: "/")
//
//                let monthString = expireDateFields[0]
//                let yearString = expireDateFields[1]
//
//                var month: Int = Int()
//                var year: Int = Int()
//
//                if monthString.starts(with: "0") {
//                    month = Int(monthString.suffix(1))!
//                } else {
//                    month = Int(monthString)!
//                }
//
//                if month > 12 {
//                    textField.backgroundColor = .red.withAlphaComponent(0.3)
//                } else {
//                    textField.backgroundColor = .clear
//                }
//            } else {
//                textField.backgroundColor = .clear
//            }
            
            return false
        }
        
        // ensure only 3 character long cvc field
        if  textField == cvcTextField {
            guard let cvcInputCurrent = textField.text as? NSString else { return false }
            let cvcInputUpdated = cvcInputCurrent.replacingCharacters(in: range, with: string)
            return cvcInputUpdated.count <= 3
        }
        
        return true
    }
    
    func formatBy(pattern: String, this str: String) -> String {
        var result: String = String()
        let numbers = str.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // starting with beginning
        var index = numbers.startIndex
        for char in pattern where index < numbers.endIndex {
            if char == "#" {
                result.append(numbers[index])
                
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        
        return result
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
    
    static var cardAssociationSet: Bool = false
    
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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let uiView = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 50))
        uiView.addSubview(imageView)
        
        rightView = uiView
        rightViewMode = .always
        
        UITextField.cardAssociationSet = true
    }
    
    func removeCardAssociation() {
        rightView = nil
        rightViewMode = .never
        
        UITextField.cardAssociationSet = false
    }
    
    func addPreviousNextToolbar(onNext: (target: Any, action: Selector),
                                onPrevious: (target: Any, action: Selector)) {
        
        let toolbar: UIToolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        )
        
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
     
        let toolbar: UIToolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        )
        
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
    
        let toolbar: UIToolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        )
        
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

