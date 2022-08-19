//
//  Maestro.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct Maestro: CardProtocol {
    
    static var iinRanges: [Int] = Array(5000_00...5099_99) + Array(5600_00...5899_99) + Array(6000_00...6999_99)
    
    static var lengthRanges: [Int] = Array(12...19)
    static var pattern: [String] = ["#### #### #### ####", "#### #### #####", "#### ###### #####", "#### #### #### #### ###", "unknown"]
    static var patternByLength: [Int: String] = [
        12: "#### #### ####",
        13: pattern[1],
        14: "#### ###### ####",
        15: pattern[2],
        16: pattern[0],
        17: "#### ###### #### ###",
        18: "#### ##### ##### ####",
        19: pattern[3],
    ]
}
