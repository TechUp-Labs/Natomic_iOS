//
//  NotificationTimeVC.swift
//  Natomic
//
//  Created by Archit's Mac on 31/07/23.
//

import UIKit

class NotificationTimeVC: AlertBase {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // MARK: - Variable's : -
    
    var writingDelegate : CheckWriting?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let defaultTime = dateFormatter.date(from: "\(convertTo12HourFormat(hour: notificationHour)):\(notificationMinutes) \(notificationMeridiem)")
        timePicker.date = defaultTime ?? Date()
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.writingDelegate?.changeNotificationBTNicon()
    }
    
    // MARK: - Function For Notification Time Picker:-
    
    @objc func timePickerValueChanged() {
        let selectedTime = timePicker.date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedTime)
        let minutes = calendar.component(.minute, from: selectedTime)
        print("Selected hour (24-hour format): \(hour)")
        print("Selected hour (60-minutes format): \(minutes)")
    }
    
    func convertTo12HourFormat(hour: Int) ->  Int {
        if hour >= 0 && hour <= 23 {
            let convertedHour = hour % 12 == 0 ? 12 : hour % 12
            return convertedHour
        } else {
            fatalError("Invalid hour value. Hour should be between 0 and 23.")
        }
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func cancelBTNtapped(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func saveBTNtapped(_ sender: Any) {
        saveDataInUserDefault(value: true, key: "NOTIFICATION_ENABLE")
        let selectedTime = timePicker.date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedTime)
        let minutes = calendar.component(.minute, from: selectedTime)
        saveDataInUserDefault(value: hour, key: "Notification_Hour")
        saveDataInUserDefault(value: minutes, key: "Notification_Minutes")
        saveDataInUserDefault(value: hour >= 12 ? "PM" : "AM", key: "Notification_Meridiem")
        setUpNotification(Hour: hour, Minute: minutes)
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.2) {
            self.dismiss()
        }
    }
    
}



extension NotificationTimeVC {
    
    // MARK: - Function For Set Notification:-
    
    func setUpNotification(Hour:Int,Minute:Int) {
        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to write today!"
        content.body = "Even if it's just for a few minutes, make time to write your thoughts."
        content.sound = UNNotificationSound.default
        
        // Create a date components object for the desired time
        var dateComponents = DateComponents()
        dateComponents.hour = Hour // Set the hour (in 24-hour format) for the notification
        dateComponents.minute = Minute // Set the minute for the notification
        
        // Create a calendar trigger for the notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create a notification request with a unique identifier
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    // MARK: - Handle notification when app is in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}
