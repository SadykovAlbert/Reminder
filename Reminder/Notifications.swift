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
        let userAction = "userAction"
        let content = UNMutableNotificationContent()
        content.title = title
        //content.body = "This is example how to create \(notificationType)"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = userAction

        //
        guard let path = Bundle.main.path(forResource: "donut", ofType: "png") else {return}
        
        let url = URL(fileURLWithPath: path)

        do {
            let attachment = try UNNotificationAttachment(identifier: "donut",
                                                          url: url,
                                                          options: nil)
            content.attachments = [attachment]
        } catch {
            print("The attachment could not be louded")
        }
        //
        
        let dateMatching = Calendar.current.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error - \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: .destructive)
        
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }

   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification"{
            print("Handling notifiation with thr Local Notification Idetifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default action")
        case "Snooze":
            print("Snooze action")
            //scheduleNotification(title: "Reminder")
        case "Delete":
            print("Delete action")
            
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
}
