//
//  OderoAlertController.swift
//  
//
//  Created by Imran Hajiyev on 08.09.22.
//

import Foundation
import UIKit.UIColor

class OderoAlertController {
    // background color
    private var backgroundColor: UIColor = .clear
    
    // alert message
    private var message: String = String()
    
    // alert image
    private var imageName: String = String()
    
    // methods
    func setSuccessAlert() {
        self.backgroundColor = .green
        self.message = "Success"
        self.imageName = "checkmark.circle.fill"
    }
    
    func setWarningAlert() {
        self.backgroundColor = .yellow
        self.message = "Warning"
        self.imageName = "exclamationmark.circle.fill"
    }
    
    func setErrorAlert(ofType errorType: ErrorTypes) {
        self.backgroundColor = .red
        self.message = "\(errorType.rawValue) Error"
        self.imageName = "exclamationmark.triangle.fill"
    }
    
    func getColor() -> UIColor {
        self.backgroundColor
    }
    
    func getMessage() -> String {
        self.message
    }
    
    func getImageName() -> String {
        self.imageName
    }
}
