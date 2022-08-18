//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 16.08.22.
//

import Foundation

struct CardRepository {
    
    private var cardByIinRanges: [Int: CardAssociation] = [4: .VISA]
    
    // populate dictionary on init
    init() {
        for iin in MasterCard.iinRanges {
            cardByIinRanges[iin] = .MASTER_CARD
        }
        
        for iin in Maestro.iinRanges {
            cardByIinRanges[iin] = .MAESTRO
        }
        
        for iin in AmericanExpress.iinRanges {
            cardByIinRanges[iin] = .AMEX
         }
    }
    
    func lookUpCardAssociation(_ pattern: Int) -> CardAssociation? {
        
        if cardByIinRanges.isEmpty {
            print("Error retrieving card association data.")
        } else {
            if let cardAssociation = cardByIinRanges[pattern] {
                return cardAssociation
            }
        }
        
        return nil
    }
    
    func isVisaElectron(_ pattern: Int) -> Bool {
        VisaElectron.iinRanges.contains(pattern)
    }
}
