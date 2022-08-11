//
//  PaymentItemResult.swift
//  
//
//  Created by Imran Hajiyev on 10.08.22.
//

import Foundation

struct PaymentItemResult {
    
    var id: Int
    var name: String
    var price: Int
    var paidPrice: Int
    var walletPrice: Int
    var transactionStatus: TransactionStatus
}
