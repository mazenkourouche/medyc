//
//  EditAppointmentViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 24/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class EditAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
   

    @IBOutlet weak var appointmentNameLabel: UILabel!
    
    @IBOutlet weak var dateTextfield: UITextField!
    
    @IBOutlet weak var timeTextfield: UITextField!
    
    @IBOutlet weak var textfieldTable: UITableView!
    
    var cellTitles = ["Address", "Phone", "Notes"]
    var cellTextfields = [UITextField]()
    
    var editMode = false
    var receivedAppointment = Appointment()
    var datePicker = UIDatePicker()
    
    var receivedDate = NSDate()
    
    var addressTextfield = UITextField()
    var phoneTextfield = UITextField()
    var notesTextfield = UITextField()
    
    var appointmentsArray = [Appointment]()
   // var receivedAppointment = Appointment(name: String(), date: NSDate(), location: String(), phone: String(), notes: String(), addedToCalendar: Bool())
    var receivedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateTextfield.inputView = datePicker
        timeTextfield.inputView = datePicker
        
        datePicker.backgroundColor = UIColor.white
        
        datePicker.addTarget(self, action: #selector(EditAppointmentViewController.dateChanged(dater:)), for: UIControlEvents.valueChanged)

    }

    //var weekdayArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    func dateChanged (dater:NSDate) {
        
        let calendar = NSCalendar.current
        
        let date = self.datePicker.date
        
        let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekday, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: date)

        
        var hour = components.hour!
        
        var amPm = "AM"
        
        if components.hour! > 12 {
            hour -= 12
            amPm = "PM"
        } else if components.hour == 12 {
            amPm = "PM"
        } else if components.hour == 0 {
            hour = 12
        }
        
        var minuteString = "\(components.minute!)"
        if minuteString.characters.count == 1 {
            minuteString = "0" + minuteString
        }
        
        //let dateDay = weekdayArray[components.weekday! - 1] + "," + " \(components.day!) "
        let dateMonthNYear = monthArray[components.month! - 1] +  " \(components.day!), " + "\(components.year!)"
        let time = " \(hour):" + minuteString + " " + amPm
        let fullDate = dateMonthNYear
        
        receivedDate = date as NSDate
        
        dateTextfield.text = fullDate
        timeTextfield.text = time
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Hello"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    func addAppointment () {
        
        if appointmentNameLabel.text == "" {
            
            displayAlert(title: "Missing Information", message: "Enter an appointment title and try again")
            
        } else if dateTextfield.text == "" {
            
            displayAlert(title: "Missing Information", message: "Enter an appointment date and try again")
            
        } else {
            
            /*if notesTextview.text == "" {
                notesTextview.text = " "
            }
            if locationTextfield.text == "" {
                locationTextfield.text = " "
            }
            if phoneTextfield.text == "" {
                phoneTextfield.text = " "
            }
            */
            let alertVC = UIAlertController(title: "Add To Calendar", message: "Would you like to add this appointment to your calendar", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let newAppointment = Appointment(name: self.appointmentNameLabel.text!, date: self.receivedDate as Date, location: self.addressTextfield.text!, phone: self.phoneTextfield.text!, notes: self.notesTextfield.text!, addedToCalendar: false)
                    
                    self.appointmentsArray.append(newAppointment)
                    
                    let sortedArray = self.appointmentsArray.sort { $0.date.compare($1.date as Date) == .orderedAscending }
                    let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: sortedArray)
                    
                    UserDefaults.standard.set(appointmentsData, forKey: "appointments")
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                })
            })
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let newAppointment = Appointment(name: self.appointmentNameLabel.text!, date: self.receivedDate as Date, location: self.addressTextfield.text!, phone: self.phoneTextfield.text!, notes: self.notesTextfield.text!, addedToCalendar: true)
                    
                    self.appointmentsArray.append(newAppointment)
                    
                    
                    let sortedArray = self.appointmentsArray.sort { $0.date.compare($1.date as Date) == .orderedAscending }
                    let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: sortedArray)
                    
                    UserDefaults.standard.set(appointmentsData, forKey: "appointments")
                    
                    //self.addToCal(self.receivedDate, title: self.appointmentNameLabel.text!, notes: self.addressTextfield.text!)
                    
                })
                
            })
            
            alertVC.addAction(dismissAction)
            alertVC.addAction(addAction)
            self.present(alertVC, animated: true, completion: nil)
            
            // alertVC.view.tintColor = hexColor(0xFC0066)
            
        
        }
    }
    
    
    
    func displayAlert (title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismiss:UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        //alert.view.tintColor = hexColor(0xFC0066)
    }
}
