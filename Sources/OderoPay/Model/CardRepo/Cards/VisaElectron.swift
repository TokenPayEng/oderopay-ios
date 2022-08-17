//
//  VisaElectron.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct VisaElectron: CardProtocol {
    
    var iinRanges: [Int] = [4026, 4175_00, 4405, 4508, 4844, 4913, 4917]
    var lengthRanges: [Int] = [16]
    var pattern: [String] = ["#### #### #### ####"]
}
