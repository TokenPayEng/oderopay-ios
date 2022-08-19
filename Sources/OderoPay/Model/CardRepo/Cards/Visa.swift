//
//  Visa.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct Visa: CardProtocol {
    
    static var iinRanges: [Int] = [4]
    static var lengthRanges: [Int] = Array(13...19)
    static var pattern: [String] = ["#### #### #### ####", "unknown"]
    static var patternByLength: [Int: String] = [
        13: "#### #### #####",
        14: "#### ###### ####",
        15: "#### ###### #####",
        16: pattern.first!,
        17: "#### ###### #### ###",
        18: "#### ##### ##### ####",
        19: "#### #### #### #### ###"
    ]
}
