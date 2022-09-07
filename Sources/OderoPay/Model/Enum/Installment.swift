//
//  Installment.swift
//  
//
//  Created by Imran Hajiyev on 04.08.22.
//

import Foundation

public enum Installment: Int, Codable {
    case single = 1
    case double = 2
    case triple = 3
    case sextuple = 6
    case nonuple = 9
    case dozen = 12
}
