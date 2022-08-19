//
//  MasterCard.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct MasterCard: CardProtocol {
    
    static var iinRanges: [Int] = Array(51...55) + Array(2221_00...2720_99)
    static var lengthRanges: [Int] = [16]
    static var pattern: [String] = ["#### #### #### ####"]
    static var patternByLength: [Int: String] = [lengthRanges.first!: pattern.first!]
}
