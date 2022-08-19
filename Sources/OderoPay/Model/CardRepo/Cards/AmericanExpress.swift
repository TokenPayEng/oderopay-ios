//
//  AmericanExpress.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct AmericanExpress: CardProtocol {
    
    static var iinRanges: [Int] = [34, 37]
    static var lengthRanges: [Int] = [15]
    static var pattern: [String] = ["#### ###### #####"]
    static var patternByLength: [Int: String] = [lengthRanges.first!: pattern.first!]
}
