//
//  HomeVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit
import UserNotifications


class HomeVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var historyTBV: UITableView!
    @IBOutlet weak var notificationBTN: UIButton!
    
    // MARK: - Variable's :-
    
    var notificationTrigger : UsersNotification?
    var userData : [UserEntity]?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsersData(notification:)), name: .saveUserData, object: nil)
        historyTBV.registerCell(identifire: "HistoryTableCell")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm a"
//        let defaultTime = dateFormatter.date(from: "\(convertTo12HourFormat(hour: notificationHour)):\(notificationMinutes) \(notificationMeridiem)")
//        timePicker.date = defaultTime ?? Date()
////        timePicker.isHidden = true
//        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        self.userData = DatabaseMabager.Shared.getUserContext().reversed()
        if IS_FROME_NOTIFICATION ?? false {
            let vc = WRITING_VC
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func reloadUsersData(notification:Notification) {
        self.userData = DatabaseMabager.Shared.getUserContext().reversed()
        self.historyTBV.reloadData()
    }
    
    
    @IBAction func addNewLineBTNtapped(_ sender: Any) {
        let vc = WRITING_VC
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func notificationBTNtapped(_ sender: Any) {
        let myCustomView: TimePickerView = UIView.fromNib()
        myCustomView.frame = self.view.frame
        self.view.addSubview(myCustomView)
    }
    
    func convertTo12HourFormat(hour: Int) ->  Int {
        if hour >= 0 && hour <= 23 {
            let convertedHour = hour % 12 == 0 ? 12 : hour % 12
            return convertedHour
        } else {
            fatalError("Invalid hour value. Hour should be between 0 and 23.")
        }
    }
    
    
}

extension HomeVC: SetTableViewDelegateAndDataSorce {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        if let data = userData?[indexPath.row]{
            cell.displayData(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension HomeVC{
    
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
    
    // MARK: - Function For Set Notification:-
    
    func setUpNotification(Hour:Int,Minute:Int) {
        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Hello Dear,"
        content.body = "Please write a line...!"
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


extension Notification.Name {
    static let saveUserData = Notification.Name("SaveUserData")
}
