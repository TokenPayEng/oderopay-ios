//
//  CheckoutFormResult.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

public struct CheckoutFormResult: Codable {
    private let data: CheckoutFormDataResult?
    private let errors: CheckoutFormErrorResult?
    
    public func hasData() -> CheckoutFormDataResult? {
        data
    }
    
    public func hasErrors() -> CheckoutFormErrorResult? {
        errors
    }
}

public struct CheckoutFormDataResult: Codable {
    private let pageUrl: String
    private let token: String
    
    public func getToken() -> String {
        token
    }
    
    public func getWebViewURL() -> String {
        pageUrl
    }
}

public struct CheckoutFormErrorResult: Codable {
    private let errorCode: String
    private let errorDescription: String
    
    public func getErrorCode() -> String {
        errorCode
    }
    
    public func getErrorDescription() -> String {
        errorDescription
    }
}
