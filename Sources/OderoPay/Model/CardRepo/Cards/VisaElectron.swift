//
//  VisaElectron.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct VisaElectron: CardProtocol {
    
    static var iinRanges: [Int] = [4026, 4175_00, 4405, 4508, 4844, 4913, 4917]
    static var lengthRanges: [Int] = [16]
    static var pattern: [String] = ["#### #### #### ####"]
    static var patternByLength: [Int: String] = [lengthRanges.first!: pattern.first!]
}
