//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

enum APIGateway: String {
    case LOCAL = "http://localhost:8130"
    case SANDBOX = "https://sandbox-api-gateway.tokenpay.com.tr"
    case PROD = "https://api-gateway.tokenpay.com.tr"
}
