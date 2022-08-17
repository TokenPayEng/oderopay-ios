//
//  AmericanExpress.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct AmericanExpress: CardProtocol {
    
    var iinRanges: [Int] = [34, 37]
    var lengthRanges: [Int] = [15]
    var pattern: [String] = ["#### ###### #####"]
}
