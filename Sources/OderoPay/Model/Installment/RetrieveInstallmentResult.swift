//
//  RetrieveInstallmentResult.swift
//  
//
//  Created by Imran Hajiyev on 06.09.22.
//

import Foundation

public struct RetrieveInstallmentResult: Codable {
    private let data: RetrieveInstallmentDataResult?
    private let errors: RetrieveInstallmentErrorResult?
    
    public func hasData() -> RetrieveInstallmentDataResult? {
        data
    }
    
    public func hasErrors() -> RetrieveInstallmentErrorResult? {
        errors
    }
}

public struct RetrieveInstallmentDataResult: Codable {
    private let binNumber: String
    private let price: Double
    private let cardType: String?
    private let cardAssociation: String?
    private let cardBrand: String?
    private let bankName: String?
    private let bankCode: Int?
    private let force3ds: Bool
    private let commercial: Bool?
    private let installmentPrices: [InstallmentItem]
    
    public func getForce3ds() -> Bool {
        force3ds
    }
    
    public func getInstallmentItems() -> [InstallmentItem] {
        installmentPrices
    }
}

public struct InstallmentItem: Codable {
    private let installmentNumber: Int
    private let installmentPrice: Double
    private let totalPrice: Double
    
    public func getInstallmentNumber() -> Int {
        installmentNumber
    }
    
    public func getInstallmentPrice() -> Double {
        installmentPrice
    }
    
    public func getInstallmentTotalPrice() -> Double {
        totalPrice
    }
}

public struct RetrieveInstallmentErrorResult: Codable {
    private let errorCode: String
    private let errorDescription: String
    
    public func getErrorCode() -> String {
        errorCode
    }
    
    public func getErrorDescription() -> String {
        errorDescription
    }
}
