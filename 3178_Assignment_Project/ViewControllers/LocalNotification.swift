//
//  LocalNotification.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 18/5/2023.
//

import UserNotifications
import UIKit

func requestPermissionNotification()
{
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
    { (granted, error) in
        if !granted {
            print("Permission was not granted!")
            return
        }
    }
}



func sendNotification(transaction: Transaction, dateComponents: DateComponents, repetition: Bool)
{
    var databaseController: DatabaseProtocol?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    databaseController = appDelegate?.databaseController
    
    
    requestPermissionNotification()
    
    
    
    // Set a delayed trigger for the notification of 10 seconds
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repetition)
    
    // Create a notification content object
    let notificationContent = UNMutableNotificationContent()
    // Create its details
    notificationContent.title = "New Transaction"
    notificationContent.subtitle = "transaction to/from \(transaction.toOrFrom)"
    notificationContent.body = "The transaction of $\(transaction.amount) is scheduled to occur now"
    
    let uuid = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuid,
     content: notificationContent, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    

}



