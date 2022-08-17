//
//  Maestro.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct Maestro: CardProtocol {
    
    var iinRanges: [Int] = Array(5000_00...5099_99) + Array(5600_00...5899_99) + Array(6000_00...6999_99)
    
    var lengthRanges: [Int] = Array(12...19)
    var pattern: [String] = ["#### #### #####", "#### #### #### ####", "#### ###### #####", "#### #### #### #### ###", "unknown"]
}
