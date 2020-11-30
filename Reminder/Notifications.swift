//
//  Notifications.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else{return}
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (setting) in
            print("Notification settings: \(setting)")
        }
    }
    
    func scheduleNotification(title: String, indentifier: String, date: Date){
        
        print("New Notif \(title)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        
        let dateMatching = Calendar.current.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
        
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error - \(error.localizedDescription)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
}
