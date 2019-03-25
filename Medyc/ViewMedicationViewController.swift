//
//  ViewMedicationViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 26/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class ViewMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cellTitles = [String]()
    
    var receivedMedication = Medication()
    var receivedIndex = Int()
    
    var medInfo = [String: Any]()
    
    @IBOutlet weak var medicationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        
        medicationTable.reloadData()
    
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
            cell.nameLabel.text = receivedMedication.medName
            cell.underline.layer.cornerRadius = 5
            cell.underline.layer.masksToBounds = true
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateTableViewCell
            cell.dateLabel.text = getDate(date: receivedMedication.nextDose)
            cell.timeLabel.text = getTime(date: receivedMedication.nextDose)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! SelectedInfoTableViewCell
            cell.titleLabel.text = cellTitles[indexPath.row]
            cell.infoLabel.text = "\(medInfo[cellTitles[indexPath.row]]!) dosages"
            
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
        self.cellTitles.append("Remaining Today")
        self.cellTitles.append("Daily Intake")
        
        self.medInfo = ["Name": receivedMedication.medName, "Date": receivedMedication.nextDose, "Remaining Today": receivedMedication.dailyDosages - receivedMedication.dosesTakenToday, "Daily Intake": receivedMedication.dailyDosages]
        
    }
   
    @IBAction func edit(_ sender: Any) {
        self.performSegue(withIdentifier: "editMedication", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddMedicationViewController
        destVC.receivedInfo = [self.receivedMedication.medName, "\(self.receivedMedication.totalDosages)", "\(self.receivedMedication.dailyDosages)", "\(self.receivedMedication.requiredIntervals)"]
        destVC.receivedIndex = self.receivedIndex
        destVC.editMode = true
    }
}
