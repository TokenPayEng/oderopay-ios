//
//  FormProtocol.swift
//  
//
//  Created by Imran Hajiyev on 02.09.22.
//

import Foundation

protocol FormProtocol {
    static var isformEnabled: Bool { get set }
    static var isCardValid: Bool { get set }
    static var hasInstallment: Bool { get set }
}
