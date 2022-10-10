//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 10.10.22.
//

import Foundation

public struct MerchantSettingsResult: Codable {
    private let data: MerchantSettingsDataResult?
    private let errors: MerchantSettingsErrorResult?
    
    public func hasData() -> MerchantSettingsDataResult? {
        data
    }
    
    public func hasErrors() -> MerchantSettingsErrorResult? {
        errors
    }
}

public struct MerchantSettingsDataResult: Codable {
    private var cards: [StoredCard]?
    private var creditEnabled: Bool
    private var multicardEnabled: Bool
    private var tokenFlexEnabled: Bool
    private var pointUsageEnabled: Bool
    
    public func isCreditCardEnabled() -> Bool {
        creditEnabled
    }
    
    public func isMultipleCardsEnabled() -> Bool {
        multicardEnabled
    }
    
    public func isTokenFlexEnabled() -> Bool {
        tokenFlexEnabled
    }
    
    public func isPayByPointsEnabled() -> Bool {
        pointUsageEnabled
    }
}

public struct MerchantSettingsErrorResult: Codable {
    private let errorCode: String
    private let errorDescription: String
    
    public func getErrorCode() -> String {
        errorCode
    }
    
    public func getErrorDescription() -> String {
        errorDescription
    }
}

