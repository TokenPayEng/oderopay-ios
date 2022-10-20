//
//  PointsController.swift
//  
//
//  Created by Imran Hajiyev on 19.10.22.
//

import Foundation

public class PointsController {
    
    private var isContentOpen: Bool = false
    
    func retrievePoints() {
        print("retrieving points")
        NotificationCenter.default.post(name: Notification.Name("updateHeights"), object: nil)
    }
    
    func toggleContent(_ value: Bool) {
        self.isContentOpen = value
    }
    
    func getContentState() -> Bool {
        isContentOpen
    }
}
