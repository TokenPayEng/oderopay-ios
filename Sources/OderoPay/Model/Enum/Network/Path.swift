//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 22.08.22.
//

import Foundation

enum Path: String {
    case CHECKOUT = "/payment/v1/checkout-payments"
    case RETRIEVE_INSTALLMENTS = "/installment/v1/installments"
    case COMMON_PAYMENT_PAGE = "/common-payment-page/v1"
    case COMMON_PAYMENT_PAGE_3DS = "/common-payment-page/v1/3ds"
}
