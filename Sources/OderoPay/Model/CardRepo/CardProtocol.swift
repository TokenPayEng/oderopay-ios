//
//  CardProtocol.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

protocol CardProtocol {
    
    static var iinRanges: [Int] { get set }
    static var lengthRanges: [Int] { get set }
    static var pattern: [String] { get set }
}
