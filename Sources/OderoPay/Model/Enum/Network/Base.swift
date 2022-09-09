//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

public enum APIGateway: String {
    case LOCAL = "http://localhost:8000"
    case SANDBOX = "https://sandbox-api-gateway.tokenpay.com.tr"
    case PROD = "https://api-gateway.tokenpay.com.tr"
}
