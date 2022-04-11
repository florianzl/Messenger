//
//  PushNotificationsModel.swift
//  Messenger
//
//  Created by Florian Zitlau on 12.04.22.
//

import SwiftUI
import Foundation
import UserNotifications
import CloudKit

class PushNotificationsModel: ObservableObject {
    
    
    func requestPermissions() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permission success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.subscribeToNotifications()
            } else {
                print("Notificaton permission failure.")
            }
        }
    }
    
    private func subscribeToNotifications() {
        
        let subscription = CKQuerySubscription(recordType: "GlobalMessages", predicate: NSPredicate(value: true), subscriptionID: "globalMessageIsAddedToDatabase", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Global Chat"
        notification.alertBody = "Someone sent a new Message"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, error in
            if let error = error {
                print(error)
            } else {
                print("successfully subscribed to notifications!")
            }
        }
    }
}
