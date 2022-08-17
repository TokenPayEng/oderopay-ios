//
//  MasterCard.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct MasterCard: CardProtocol {
    
    var iinRanges: [Int] = Array(51...55) + Array(2221_00...2720_99)
    var lengthRanges: [Int] = [16]
    var pattern: [String] = ["#### #### #### ####"]
}
