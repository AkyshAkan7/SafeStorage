//
//  UserDefault.swift
//  SafeStorage
//
//  Created by Akan Akysh on 5/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class UserDefault {
    
    private static let notificationKey: String = "Notifications"
    private static let unreadNotificationKey: String = "UnreadNotifications"
    
    static func loadNotifications() {
        if let data = UserDefaults.standard.value(forKey: notificationKey) as? Data {
            NotificationManager.shared.notifications = try! PropertyListDecoder().decode(Array<Notification>.self, from: data)
        }
    }
    
    static func saveNotifications() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(NotificationManager.shared.notifications), forKey: notificationKey)
    }
    
    static func loadNotificationsCount() {
        let count = UserDefaults.standard.integer(forKey: unreadNotificationKey)
        NotificationManager.shared.unreadMessages = count
    }
    
    static func saveNotificationsCount() {
        UserDefaults.standard.set(NotificationManager.shared.unreadMessages, forKey: unreadNotificationKey)
    }
}
