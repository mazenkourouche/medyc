//
//  AppointmentsViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import EventKit

class AppointmentsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var topCalendar: FSCalendar!
    
    @IBOutlet weak var noAppointmentsView: UIView!
   
    var sectionTitles = ["MORNING", "AFTERNOON", "EVENING", "NIGHT"]
    var currentTitles = [String]()
    var currentCategories = [false, false, false, false]
    
    var arrangedArray = [String:[Appointment]]()
    
    @IBOutlet weak var appointmentsTable: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    var appointmentsArray = [Appointment]()
    
    var currentAppointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topCalendar.setScope(.week, animated: false)

        topCalendar.select(Date())
        
        appointmentsTable.tableFooterView = UIView()
        appointmentsTable.backgroundColor = UIColor.groupTableViewBackground
        
        print(topCalendar.calendarWeekdayView.frame.height)
         print(topCalendar.calendarHeaderView.frame.height)
        
        
        if UserDefaults.standard.object(forKey: "appointments") == nil {
            let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: self.appointmentsArray)
            UserDefaults.standard.set(appointmentsData, forKey: "appointments")
            
        }
        
        
        reloadInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        if date == Date() {
            return 0.0
        }
    
        return 1.0
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //currentAppointments.removeAll()
        
        /*
        for appointment in appointmentsArray {
            let calendar = Calendar.current
            if calendar.isDate(appointment.date, inSameDayAs: date) {
                currentAppointments.append(appointment)
            }
        }*/
        
        reloadInfo()
        
        print(currentAppointments.count)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter1.string(from: date)
        
        for appointment in appointmentsArray {
            
            if self.dateFormatter1.string(from: appointment.date) == dateString {
                return 1
            }
            
        }
        
        return 0
        
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        _ = self.dateFormatter2.string(from: date)
        return UIColor.purple
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EventTableViewCell
        
        let selectedArray = arrangedArray[currentTitles[indexPath.section].lowercased()]
        
        cell.eventTitleLabel.text = selectedArray?[indexPath.row].name
        cell.eventTimeLabel.text = getTime(date: (selectedArray?[indexPath.row].date)!)
        
        return cell

    }
    
    func getTime(date: Date) -> String {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekday, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: date)
        
        var hour = components.hour!
        
        var amPm = "am"
        
        if components.hour! > 12 {
            hour -= 12
            amPm = "pm"
        } else if components.hour == 12 {
            amPm = "pm"
        } else if components.hour == 0 {
            hour = 12
        }
        
        var minuteString = "\(components.minute!)"
        if minuteString.characters.count == 1 {
            minuteString = "0" + minuteString
        }
        
        
        let time = " \(hour):" + minuteString + " " + amPm
        
        return time
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return currentTitles.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedArray = arrangedArray[currentTitles[section].lowercased()]
        return selectedArray!.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        reloadInfo()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentTitles[section]
    }
    
    func reloadInfo () {
        
        arrangedArray.removeAll()
        currentTitles.removeAll()
        currentCategories = [false, false, false, false]
        
        for title in sectionTitles {
            
            arrangedArray[title.lowercased()] = [Appointment]()
            
        }
        
        let appointmentsData = UserDefaults.standard.object(forKey: "appointments") as? NSData
        
        
        if let appointmentsData = appointmentsData {
            appointmentsArray = NSKeyedUnarchiver.unarchiveObject(with: appointmentsData as Data) as! [Appointment]
            
            print("COUNT")
            print(appointmentsArray.count)
        }
        
        for appointment in appointmentsArray {
            
            let calendar = Calendar.current
            if calendar.isDate(appointment.date, inSameDayAs: topCalendar.selectedDate!) {
                let category = appointmentCategory(date: appointment.date)
                currentCategories[sectionTitles.index(of: category.uppercased())!] = true
                arrangedArray[appointmentCategory(date: appointment.date)]?.append(appointment)
            }
            
        }
        
        for (index, category) in currentCategories.enumerated() {
            if category {
                currentTitles.append(sectionTitles[index])
            }
        }
        
        if currentTitles.count == 0 {
            noAppointmentsView.isHidden = false
        } else {
            noAppointmentsView.isHidden = true
        }
        
        appointmentsTable.reloadData()
        topCalendar.reloadData()
        
    }
    
    func appointmentCategory (date: Date) -> String {
        
        let hour = Calendar.current.component(.hour, from: date)
        
        if hour >= 5 && hour < 12 {
            return "morning"
        } else if hour >= 12 && hour < 5 {
            return "afternoon"
        } else if hour >= 5 && hour < 9 {
            return "evening"
        } else {
            return "night"
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var containerArray = arrangedArray[currentTitles[indexPath.row].lowercased()]!
        let currentApp = containerArray[indexPath.row]
        let selectedAppointmentIndex = appointmentsArray.index(of: currentApp)
        
        let button = UIButton()
        button.tag = selectedAppointmentIndex!
        
        self.performSegue(withIdentifier: "viewAppointment", sender: button)
    }

    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "addAppointment", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewAppointment" {
            
            let object:UIButton = sender as! UIButton
            let destVC = segue.destination as! ViewAppointmentViewController
            destVC.receivedAppointment = appointmentsArray[object.tag]
            destVC.receivedIndex = object.tag
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
        } else {
            
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
           
        }
        
    }
    
    
    func deleteAppointment (index: Int, array: [Appointment]) {
        
        let alertVC = UIAlertController(title: "Delete Appointment", message: "Would you llike to remove this appointment?", preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let appToRemove = self.appointmentsArray[self.appointmentsArray.index(of: array[index])!]
            
            for notif in UIApplication.shared.scheduledLocalNotifications! {
                if let firedate = notif.fireDate {
                    if firedate == appToRemove.date.addingTimeInterval(-(5 * 60)) {
                        UIApplication.shared.cancelLocalNotification(notif)
                    }
                }
            }
            
            
            let startDate = appToRemove.date
            var endDate = Date()
            let title = appToRemove.name
            let store = EKEventStore()
            
            let mytime = NSTimeZone.local
            var calendar = NSCalendar.current
            calendar.timeZone = mytime
            var myInterval = DateComponents()
            myInterval.hour = 1
            endDate = calendar.date(byAdding: myInterval, to: startDate)!
            
            store.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                
                if granted {
                    
                    let calendars = store.calendars(for: .event)
                    let events = store.events(matching: store.predicateForEvents(withStart: startDate, end: endDate as Date, calendars: calendars))
                    print(events.count)
                    for event in events {
                        if event.title == title {
                            
                            do {
                                try store.remove(event, span: .thisEvent)
                                
                            } catch {
                                
                            }
                            
                        }
                    }
                }
                
                
            })
            
            
            self.appointmentsArray.remove(at: self.appointmentsArray.index(of: array[index])!)
            
            
            let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: self.appointmentsArray)
            UserDefaults.standard.set(appointmentsData, forKey: "appointments")
            
            
            self.reloadInfo()
            
            
        })
        
        alertVC.addAction(dismissAction)
        alertVC.addAction(deleteAction)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        })
        
        alertVC.view.tintColor = UIColor(netHex:0x1F91F0)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var containerArray = arrangedArray[currentTitles[indexPath.row].lowercased()]!
        let currentApp = containerArray[indexPath.row]
        
        let addToCalendar = UITableViewRowAction(style: .normal, title: "    Add to calendar     ") { action, index in
            
            self.addToCalendarButtonTapped(index: indexPath.row, array: containerArray)
            
        }
        
        addToCalendar.backgroundColor = UIColor(netHex: 0x5D73FD)
        //addToCalendar.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellAddToCalendar")!)
        
        let trash = UITableViewRowAction(style: .normal, title: "    Delete     ") { action, index in
            print("trash button tapped")
            self.deleteAppointment(index: indexPath.row, array: containerArray)
        }
        trash.backgroundColor = UIColor(netHex: 0xDA1A4B)
        //trash.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellTrash")!)
        
        if currentApp.addedToCalendar {
            return [trash]
        } else {
            return [trash, addToCalendar]
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    func addToCalendarButtonTapped(index: Int, array: [Appointment]) {
        
        let indexToUse = appointmentsArray.index(of: array[index])!
        
        addToCal(startDate: array[index].date, title: array[index].name, notes: array[index].notes, tag: indexToUse)
        
    }
    
    func addToCal (startDate: Date, title: String, notes: String, tag: Int) {
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if(EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                
                let eventAlert = UIAlertController(title: "Authorise Calendar", message: "Authorise calendar access in: Settings > Privacy > Calendars", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                eventAlert.addAction(dismissAction)
                self.present(eventAlert, animated: true, completion: nil)
               // eventAlert.view.tintColor = hexColor(0x1F91F0)
                
            } else {
                
                self.createEvent(eventStore: eventStore, title: title, startDate: startDate, notes: notes, tag: tag)
                
            }
            
        })
        
        
        
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, notes: String, tag: Int)  {
        let event = EKEvent(eventStore: eventStore)
        
        let mytime = NSTimeZone.local
        var calendar = NSCalendar.current
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
            
            appointmentsArray[tag].addedToCalendar = true
            
            print(appointmentsArray[tag].addedToCalendar)
            let appointmentsData = NSKeyedArchiver.archivedData(withRootObject: self.appointmentsArray)
            UserDefaults.standard.set(appointmentsData, forKey: "appointments")
            
            reloadInfo()
            
            displayCalendarView(title: "Added To Calendar", message: "Your appointment has successfully been added to your calendar")
        } catch {
            displayCalendarView(title: "A Problem Occurred", message: "Please try again later")
        }
        
    }
    
    func displayCalendarView(title: String, message: String) {
        
        let calendarAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            
            self.appointmentsTable.setEditing(false, animated: true)
            self.reloadInfo()
            
        }
        
        calendarAlertController.addAction(dismissAction)
        
        DispatchQueue.main.async() {
            self.present(calendarAlertController, animated: true, completion: nil)
        }
        
    }
    
    
}
