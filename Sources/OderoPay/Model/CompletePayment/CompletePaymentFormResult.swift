//
//  CompletePaymentFormResult.swift
//  
//
//  Created by Imran Hajiyev on 07.09.22.
//

import Foundation

public class CompletePaymentFormResult: Codable {
    private let data: CompletePaymentFormDataResult?
    private let errors: CompletePaymentFormErrorResult?
    
    public func hasData() -> CompletePaymentFormDataResult? {
        data
    }
    
    public func hasErrors() -> CompletePaymentFormErrorResult? {
        errors
    }
}

public struct CompletePaymentFormDataResult: Codable {
    private let htmlContent: String
    
    public func getHtmlContent() -> String {
        htmlContent
    }
}

public struct CompletePaymentFormErrorResult: Codable {
    private let errorCode: String
    private let errorDescription: String
    
    public func getErrorCode() -> String {
        errorCode
    }
    
    public func getErrorDescription() -> String {
        errorDescription
    }
}
