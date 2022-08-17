//
//  CardProtocol.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

protocol CardProtocol {
    
    var iinRanges: [Int] { get set }
    var lengthRanges: [Int] { get set }
    var pattern: [String] { get set }
}
