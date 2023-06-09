//
//  LocalNotification.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 18/5/2023.
//

import UserNotifications
import UIKit

func requestPermissionNotification(controller: UIViewController)
{
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
    { (granted, error) in
        if !granted {
            DispatchQueue.main.async {
                displayMessage(controller: controller, title: "Notification Disabled", message: "Notifications will not be sent due to notification being disabled")
            }
            return
        }
    }
}



func sendNotification(controller: UIViewController, transaction: Transaction, dateComponents: DateComponents, repetition: Bool)
{
    var databaseController: DatabaseProtocol?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    databaseController = appDelegate?.databaseController
    
    
    requestPermissionNotification(controller: controller)
    
    // Set a delayed trigger for the notification of 10 seconds
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repetition)
    
    // Create a notification content object
    

    let notificationContent = UNMutableNotificationContent()
    // Create its details
    
    if transaction.transactionType == 2
    {
        notificationContent.title = "Reminder: Lending is due"
        notificationContent.subtitle = "Lending to \(transaction.toFrom ?? "")"
        notificationContent.body = "The Lending of $\(abs(transaction.amount)) is due now"
    }
    else
    {
        notificationContent.title = "\(String(describing: TransactionType(rawValue: transaction.transactionType))) + Reminder"
        notificationContent.subtitle = "transaction to/from \(transaction.toFrom ?? "")"
        notificationContent.body = "The transaction of $\(abs(transaction.amount)) is scheduled to occur now"
    }
    
    let uuid = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuid,
     content: notificationContent, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    

}



