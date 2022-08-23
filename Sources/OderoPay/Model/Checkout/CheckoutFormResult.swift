//
//  CheckoutFormResult.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

public struct CheckoutFormResult: Codable {
    private let pageUrl: String
    private let token: String
    
    public func getToken() -> String {
        token
    }
    
    public func getWebViewURL() -> String {
        pageUrl
    }
}
