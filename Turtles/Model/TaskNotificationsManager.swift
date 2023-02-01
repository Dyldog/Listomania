//
//  TaskNotificationsManager.swift
//  Listomania
//
//  Created by Dylan Elliott on 25/10/21.
//

import Foundation
import UserNotifications

class TaskNotificationsManager {
    static func scheduleNotifications(forNewManifest manifest: Manifest) {
        NotificationHandler.shared.addNotification(
            id: manifest.id.uuidString,
            title: "Tasks remaining for \(manifest.title)",
            subtitle: nil,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        )
    }
    
    static func removeNotifications(forManifest manifest: Manifest) {
        NotificationHandler.shared.removeNotifications([manifest.id.uuidString])
    }
    
    static func handleTaskCompletion(forManifest manifest: Manifest) {
        if manifest.completed {
            removeNotifications(forManifest: manifest)
        } else {
            removeNotifications(forManifest: manifest)
            scheduleNotifications(forNewManifest: manifest)
        }
    }
}
