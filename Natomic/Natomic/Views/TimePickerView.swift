//
//  TimePickerView.swift
//  Natomic
//
//  Created by Archit's Mac on 25/07/23.
//

import UIKit

class TimePickerView: UIView {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    // MARK: - UIView Life Cycle:-
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let defaultTime = dateFormatter.date(from: "\(convertTo12HourFormat(hour: notificationHour)):\(notificationMinutes) \(notificationMeridiem)")
        timePicker.date = defaultTime ?? Date()
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Handle touch began event
        if let touch = touches.first {
            let location = touch.location(in: self)
            // Do something with the touch location
            print("Touch began at: \(location)")
            self.removeFromSuperview()
        }
    }
    
    // MARK: - All Fuction's : -
    
    // MARK: - Function For Notification Time Picker:-
    
    @objc func timePickerValueChanged() {
        let selectedTime = timePicker.date
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedTime)
        let minutes = calendar.component(.minute, from: selectedTime)
        print("Selected hour (24-hour format): \(hour)")
        print("Selected hour (60-minutes format): \(minutes)")
        saveDataInUserDefault(value: hour, key: "Notification_Hour")
        saveDataInUserDefault(value: minutes, key: "Notification_Minutes")
        saveDataInUserDefault(value: hour >= 12 ? "PM" : "AM", key: "Notification_Meridiem")
        setUpNotification(Hour: hour, Minute: minutes)
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
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}

extension TimePickerView{
    // MARK: - Function For Set Notification:-
    
    func setUpNotification(Hour:Int,Minute:Int) {
        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Capture Your Thoughts: Write It Down!"
        content.body = "📝 Don't let those brilliant ideas slip away! Set aside some time today to jot down your thoughts, whether it's a new project, a creative spark, or just something you don't want to forget. Writing it down is the first step towards making it a reality. 🚀 #StayProductive"
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
