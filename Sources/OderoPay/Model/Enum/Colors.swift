//
//  File.swift
//  
//
//  Created by Imran Hajiyev on 13.09.22.
//

import Foundation
import UIKit

public enum OderoColors {
    case success
    case warning
    case error
    case gray
    case black
}

extension OderoColors {
    var color: UIColor {
        switch self {
        case .success:
            return UIColor(red: 108/255, green: 209/255, blue: 78/255, alpha: 1)
        case .warning:
            return UIColor(red: 247/255, green: 158/255, blue: 27/255, alpha: 1)
        case .error:
            return UIColor(red: 235/255, green: 0/255, blue: 27/255, alpha: 1)
        case .gray:
            return UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        case .black:
            return UIColor(red: 4/255, green: 16/255, blue: 48/255, alpha: 1)
        }
    }
    
    var cgColor: CGColor {
        switch self {
        case .success:
            return UIColor(red: 108/255, green: 209/255, blue: 78/255, alpha: 1).cgColor
        case .warning:
            return UIColor(red: 247/255, green: 158/255, blue: 27/255, alpha: 1).cgColor
        case .error:
            return UIColor(red: 235/255, green: 0/255, blue: 27/255, alpha: 1).cgColor
        case .gray:
            return UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        case .black:
            return UIColor(red: 4/255, green: 16/255, blue: 48/255, alpha: 1).cgColor
        }
    }
}
