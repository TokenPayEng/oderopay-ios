//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

public enum APIGateway: String {
    case SANDBOX = "https://sandbox-api-gateway.oderopay.com.tr"
    case PROD_TR = "https://api-gateway.oderopay.com.tr"
    case PROD_AZ = "https://api-gateway.odero.az"
    
    func getBaseURL() -> String {
        switch self {
        case .SANDBOX:
            return "https://sandbox-oos.oderopay.com.tr"
        case .PROD_TR:
            return "https://oos.oderopay.com.tr"
        case .PROD_AZ:
            return "https://oos.odero.az"
        }
    }
}

public enum Environment {
    case SANDBOX_TR
    case SANDBOX_AZ
    case PROD_TR
    case PROD_AZ
    
    func getGateway() -> APIGateway {
        switch self {
        case .SANDBOX_TR:
            return APIGateway.SANDBOX
        case .SANDBOX_AZ:
            return APIGateway.SANDBOX
        case .PROD_TR:
            return APIGateway.PROD_TR
        case .PROD_AZ:
            return APIGateway.PROD_AZ
        }
    }
}
