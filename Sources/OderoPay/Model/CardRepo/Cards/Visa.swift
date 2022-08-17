//
//  Visa.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct Visa: CardProtocol {
    
    var iinRanges: [Int] = [4]
    var lengthRanges: [Int] = Array(13...19)
    var pattern: [String] = ["#### #### #### ####", "unknown"]
}
