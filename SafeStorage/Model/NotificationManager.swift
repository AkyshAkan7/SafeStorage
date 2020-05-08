//
//  NotificationManager.swift
//  SafeStorage
//
//  Created by Akan Akysh on 5/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    var notifications: [Notification] = []
    
    var unreadMessages: Int = 0
    
    func addNotification(forItem item: String) {
        UserDefault.loadNotifications()
        notifications.append(Notification(text: "Вещь \(item) оформлен для рассмотрения"))
        UserDefault.saveNotifications()
    }
    
    func addUnreadMessage() {
        UserDefault.loadNotificationsCount()
        unreadMessages += 1
        UserDefault.saveNotificationsCount()
    }
    
    func markAsRead() {
        unreadMessages = 0
        UserDefault.saveNotificationsCount()
    }
}
