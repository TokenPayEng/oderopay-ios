//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

public enum APIGateway: String {
    case SANDBOX = "https://sandbox-api-gateway.tokenpay.com.tr"
    case PROD_TR = "https://api-gateway.oderopay.com.tr"
    case PROD_AZ = "https://api-gateway.odero.az"
    
    func getOOS() -> String {
        switch self {
        case .SANDBOX:
            return "https://sandbox-oos.tokenpay.com.tr"
        case .PROD_TR:
            return "https://oos.oderopay.com.tr"
        case .PROD_AZ:
            return "https://oos.odero.az"
        }
    }
}
