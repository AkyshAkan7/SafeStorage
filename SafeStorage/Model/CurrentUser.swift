//
//  CurrentUser.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/19/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class CurrentUser: NSObject {
    var user = User()
    static let shared = CurrentUser()
    
    func getFullName() -> String? {
        
        if let firstName = user.firstName, let surName = user.surName, let middleName = user.middleName {
            return firstName + " " + surName + " " + middleName
        }
        
        return nil
    }
}
