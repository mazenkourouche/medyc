//
//  ViewAppointmentViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 26/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class ViewAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cellTitles = [String]()
    
    var receivedAppointment = Appointment()
    var receivedIndex = Int()
    
    var appInfo = [String: Any]()
    
    @IBOutlet weak var appointmentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        
        appointmentTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! NameTableViewCell
            cell.nameLabel.text = receivedAppointment.name
            cell.underline.layer.cornerRadius = cell.underline.frame.height/2
            //cell.underline.layer.masksToBounds = true
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateTableViewCell
            cell.dateLabel.text = getDate(date: receivedAppointment.date)
            cell.timeLabel.text = getTime(date: receivedAppointment.date)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! SelectedInfoTableViewCell
            cell.titleLabel.text = cellTitles[indexPath.row]
            
            print(cellTitles[indexPath.row])
            cell.infoLabel.text = "\(appInfo[cellTitles[indexPath.row]]!)"
            
            return cell
        }
    }
    
    var monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    func getDate (date:Date) -> String {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekday, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: date)
        
        let dateMonthNYear = monthArray[components.month! - 1] +  " \(components.day!), " + "\(components.year!)"
        
        return dateMonthNYear
        
    }
    
    func getTime (date:Date) -> String {
        
        let calendar = NSCalendar.current
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 75
        default:
            return 65
        }
    }
    
    func setupTable () {
        
        //Leave as 'append' to add if statements
        self.cellTitles.append("Name")
        self.cellTitles.append("Date")
        
        if receivedAppointment.location != "" {
            self.cellTitles.append("Address")
            self.appInfo["Address"] = receivedAppointment.location
        }
        
        if receivedAppointment.phone != "" {
            self.cellTitles.append("Phone")
            self.appInfo["Phone"] = receivedAppointment.phone
        }
        
        if receivedAppointment.notes != "" {
            self.cellTitles.append("Notes")
            self.appInfo["Notes"] = receivedAppointment.notes
        }
        
        
    }
    
    @IBAction func edit(_ sender: Any) {
        
        self.performSegue(withIdentifier: "editAppointment", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddAppointmentViewController
        destVC.receivedIndex = self.receivedIndex
        destVC.receivedInfo = [self.receivedAppointment.name, getDate(date: self.receivedAppointment.date) + " " + getTime(date: self.receivedAppointment.date), self.receivedAppointment.location, self.receivedAppointment.phone, self.receivedAppointment.notes]
        destVC.editMode = true
    }
    
    
}
