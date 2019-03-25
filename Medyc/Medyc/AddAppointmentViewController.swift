//
//  AddAppointmentViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 24/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import EventKit

class AddAppointmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var cellTitles = ["Clinic Name", "Date", "Address", "Phone", "Notes"]
    
    var receivedAppointment = Appointment()
    var receivedDate = Date()
    var appointmentsArray = [Appointment]()
    
    var nameTextfield = UITextField()
    var dateTextfield = UITextField()
    var addressTextfield = UITextField()
    var phoneTextfield = UITextField()
    var notesTextfield = UITextField()
    var datePicker = UIDatePicker()
    var cellTextfields = [UITextField]()
    
    var receivedIndex = Int()
    var receivedInfo = ["", "", "", "", ""]

    var editMode = false
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var appointmentTable: UITableView!
    
     var monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.backItem?.title = ""
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        if receivedInfo[0] != "" {
            self.title = "Edit Appointment"
        } else {
            self.title = "New Appointment"
        }
        
        cellTextfields.append(nameTextfield)
        cellTextfields.append(dateTextfield)
        cellTextfields.append(addressTextfield)
        cellTextfields.append(phoneTextfield)
        cellTextfields.append(notesTextfield)

        appointmentTable.tableFooterView = UIView()
        
        let appointmentsData = UserDefaults.standard.object(forKey: "appointments") as? NSData
        if let appointmentsData = appointmentsData {
            appointmentsArray = (NSKeyedUnarchiver.unarchiveObject(with: appointmentsData as Data) as? [Appointment])!
        } else {
            let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: [Appointment]())
            
            UserDefaults.standard.set(appointmentsData, forKey: "appointments")
        }
        
        datePicker.backgroundColor = UIColor.white
        
        datePicker.addTarget(self, action: #selector(EditAppointmentViewController.dateChanged(dater:)), for: UIControlEvents.valueChanged)
        
       // self.navBar.title = "Appointment"
        
    }
    
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
        let fullDate = dateMonthNYear + time
        
        receivedDate = date as Date
        
        self.cellTextfields[1].text = fullDate
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Hello"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return cellTitles.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TextfieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextfieldTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = cellTitles[indexPath.row]
            cellTextfields[indexPath.row] =  cell.inputTextfield
            cell.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                cell.inputTextfield.autocapitalizationType = .words
            case 1:
                cell.inputTextfield.inputView = datePicker
            case 2:
                cell.inputTextfield.autocapitalizationType = .words
            case 3:
                cell.inputTextfield.keyboardType = .phonePad
            case 4:
                cell.inputTextfield.autocapitalizationType = .sentences
            default:
                break
            }
            
            cell.inputTextfield.text = receivedInfo[indexPath.row]
            
        case 1:
            cell.titleLabel.text = "Delete Appointment"
            cell.inputTextfield.isHidden = true
            cell.titleLabel.textColor = .red
            cell.titleLabel.sizeToFit()
        default:
            break
        }
        
        cell.inputTextfield.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return " "
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 85
        case 1:
            return 45
        default:
            return 0
            
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            cellTextfields[indexPath.row].becomeFirstResponder()
        } else {
            //delete
        }
    }
    
    
    func setPlaceholders () {
        
    }
    
    @IBAction func cancel(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        addAppointment()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func reassignTextfields () {
        nameTextfield = cellTextfields[0]
        addressTextfield = cellTextfields[2]
        phoneTextfield = cellTextfields[3]
        notesTextfield = cellTextfields[4]
    }
    func addAppointment () {
        
        reassignTextfields()
        
        if cellTextfields[0].text == "" {
            
            displayAlert(title: "Missing Information", message: "Enter an appointment title and try again")
            
        } else if cellTextfields[1].text == "" {
            
            displayAlert(title: "Missing Information", message: "Enter an appointment date and try again")
            
        } else {
            
            if editMode {
                self.appointmentsArray.remove(at: receivedIndex)
            }
            
            let alertVC = UIAlertController(title: "Add To Calendar", message: "Would you like to add this appointment to your calendar", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let newAppointment = Appointment(name: self.nameTextfield.text!, date: self.receivedDate, location: self.addressTextfield.text!, phone: self.phoneTextfield.text!, notes: self.notesTextfield.text!, addedToCalendar: false)
                    
                    self.appointmentsArray.append(newAppointment)
                    
                    let sorted = self.appointmentsArray.sorted(by: {$0.date.compare($1.date as Date) == .orderedAscending})

                   
                    
                    let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: sorted)
                    
                    UserDefaults.standard.set(appointmentsData, forKey: "appointments")
                    self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil)
                    
                })
            })
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let newAppointment = Appointment(name: self.nameTextfield.text!, date: self.receivedDate, location: self.addressTextfield.text!, phone: self.phoneTextfield.text!, notes: self.notesTextfield.text!, addedToCalendar: false)
                    
                    self.appointmentsArray.append(newAppointment)
                    
                    let sorted = self.appointmentsArray.sorted(by: {$0.date.compare($1.date as Date) == .orderedAscending})
                    
                    
                    
                    let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: sorted)
                    
                    UserDefaults.standard.set(appointmentsData, forKey: "appointments")
                    
                    self.addToCal(startDate: self.receivedDate as NSDate, title: self.nameTextfield.text!, notes: self.addressTextfield.text!)
                    
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
    
    func addToCal (startDate: NSDate, title: String, notes: String) {
        
        let eventStore = EKEventStore()
        
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if(EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                
                let eventAlert = UIAlertController(title: "Authorise Calendar", message: "Authorise calendar access in: Settings > Privacy > Calendars", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil)
                })
                eventAlert.addAction(dismissAction)
                self.present(eventAlert, animated: true, completion: nil)
                //eventAlert.view.tintColor = hexColor(0x1F91F0)
                
            } else {
                
                self.createEvent(eventStore: eventStore, title: title, startDate: startDate as Date, notes: notes)
                
            }
            
        })
        
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, notes: String)  {
        let event = EKEvent(eventStore: eventStore)
        
        let mytime = NSTimeZone.local
        var calendar = Calendar.current
        calendar.timeZone = mytime
        var myInterval = DateComponents()
        myInterval.hour = 1
        
        event.title = title
        event.notes = notes
        event.startDate = startDate
        event.endDate = calendar.date(byAdding: myInterval, to: startDate)!
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            DispatchQueue.main.async(execute: {
                self.displayCalendarView(title: "Added To Calendar", message: "Your appointment has successfully been added to your calendar")
            })
            
        } catch {
            print("Bad things happen")
        }
        
    }
    
    
    func displayCalendarView(title: String, message: String) {
        
        let calendarAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            DispatchQueue.main.async(execute: {
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        calendarAlertController.addAction(dismissAction)
        
        DispatchQueue.main.async(execute: {
            self.present(calendarAlertController, animated: true, completion: nil)
        })
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if editMode {
            return 1
        } else {
            return 1
            
        }
        
    }
    
}
