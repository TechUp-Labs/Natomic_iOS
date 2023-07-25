//
//  ProfileVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var DOBTextField: UITextField!
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .time
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DOBTextField.inputView = datePicker
        //        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        addDoneButtonToPicker()
    }
    
    @IBAction func tap(_ sender: Any) {
        
    }
    
    func addDoneButtonToPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDatePickeraa))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: true)
        DOBTextField.inputAccessoryView = toolBar
    }

    @objc func handleDatePickeraa() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        DOBTextField.text = dateFormatter.string(from: datePicker.date)
        DOBTextField.resignFirstResponder() // Dismiss the picker
    }

    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        DOBTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
}

