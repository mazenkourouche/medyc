//
//  MedicationsViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 24/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class MedicationsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var sectionTitles = ["MORNING", "AFTERNOON", "EVENING", "NIGHT"]
    var currentTitles = [String]()
    var currentCategories = [false, false, false, false]
    
    var medicationsArray = [Medication]()
    var arrangedArray = [String:[Medication]]()
    @IBOutlet weak var noMedicationsView: UIView!

    @IBOutlet weak var topCalendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var medicationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topCalendar.setScope(.week, animated: false)
        topCalendar.select(Date())
        
        medicationsTable.tableFooterView = UIView()
        medicationsTable.backgroundColor = UIColor.groupTableViewBackground
        
        print(topCalendar.calendarWeekdayView.frame.height)
        print(topCalendar.calendarHeaderView.frame.height)

        if UserDefaults.standard.object(forKey: "medications") == nil {
            let medicationsData = NSKeyedArchiver.archivedData(withRootObject: self.medicationsArray)
            UserDefaults.standard.set(medicationsData, forKey: "medications")
            
        }
        
        reloadInfo()
        
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
        
       
        reloadInfo()
        
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter1.string(from: date)
        
        for medication in medicationsArray {
            
            if self.dateFormatter1.string(from: medication.nextDose) == dateString {
                return 1
            }
            
        }
        
        return 0
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        _ = self.dateFormatter2.string(from: date)
        return UIColor.purple
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.eventTitleLabel.text = selectedArray?[indexPath.row].medName
        cell.eventTimeLabel.text = getTime(date: (selectedArray?[indexPath.row].nextDose)!)
        
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
            
            arrangedArray[title.lowercased()] = [Medication]()
            
        }
        
        let medicationsData = UserDefaults.standard.object(forKey: "medications") as? NSData
        
        if let medicationsData = medicationsData {
            medicationsArray = NSKeyedUnarchiver.unarchiveObject(with: medicationsData as Data) as! [Medication]
            
            print("COUNT")
            print(medicationsArray.count)
            
        }
        
        medicationsArray = medicationsArray.sorted { $0.nextDose.compare($1.nextDose) == .orderedAscending }
        
        for medication in medicationsArray {
            
            let calendar = Calendar.current
            if calendar.isDate(medication.nextDose, inSameDayAs: topCalendar.selectedDate!) {
                let category = medicationCategory(date: medication.nextDose)
                print(category)
                currentCategories[sectionTitles.index(of: category.uppercased())!] = true
                arrangedArray[medicationCategory(date: medication.nextDose)]?.append(medication)
            }
            
        }
        
        for (index, category) in currentCategories.enumerated() {
            
            if category {
                print(sectionTitles[index])
                currentTitles.append(sectionTitles[index])
            }
        }
        
        if currentTitles.count == 0 {
            noMedicationsView.isHidden = false
        } else {
            noMedicationsView.isHidden = true
        }
        
        for med in medicationsArray {
            print(med.medName)
            print(med.nextDose)
        }
        
        print(medicationsArray.count)
        medicationsTable.reloadData()
        topCalendar.reloadData()
        
    }
    
    func medicationCategory (date: Date) -> String {
        
        let hour = Calendar.current.component(.hour, from: date)
        print(hour)
        if hour >= 5 && hour < 12 {
            return "morning"
        } else if hour >= 12 && hour < 17 {
            return "afternoon"
        } else if hour >= 17 && hour < 21 {
            return "evening"
        } else {
            return "night"
        }
        
    }
    
    @IBAction func add(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addMedication", sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func logDosage(indexPath: IndexPath) {
        
        let tappedArray = arrangedArray[currentTitles[indexPath.section].lowercased()]!
        let tappedIndex = tappedArray[indexPath.row]
        print(tappedIndex)
        let realIndex = medicationsArray.index(of: (tappedArray[indexPath.row]))!
        
        if medicationsArray[realIndex].dosesTakenToday == medicationsArray[realIndex].dailyDosages {
            
            let alertVC = UIAlertController(title: "Too many dosages", message: "You may only log your prescribed number of dosages", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertVC.addAction(dismissAction)
            self.present(alertVC, animated: true, completion: nil)
            alertVC.view.tintColor = UIColor(netHex: 0x1F91F0)
            
        } else if (medicationsArray[realIndex].nextDose.isGreaterThanDate(dateToCompare: Date())) {
            
            let alertVC = UIAlertController(title: "Too Early", message: "You may not log a dosage before the prescribed time", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertVC.addAction(dismissAction)
            self.present(alertVC, animated: true, completion: nil)
            alertVC.view.tintColor = UIColor(netHex: 0x1F91F0)
            
        } else {
            
            medicationsArray[realIndex].dosesTakenToday += 1
            medicationsArray[realIndex].totalDosages -= 1
            medicationsArray[realIndex].dateLogged = Date()
            medicationsArray[realIndex].nextDose = integerInterval(index: realIndex, date: medicationsArray[realIndex].dateLogged)
            
            medicationsArray[realIndex].nextDose = checkNewDoseRequirement(nextDate: medicationsArray[realIndex].nextDose)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            print(formatter.string(from: medicationsArray[realIndex].nextDose))
            let notification:UILocalNotification = UILocalNotification()
            notification.alertTitle = "Next Dosage"
            
            notification.alertBody = "Is it time for your next dosage?"
            notification.fireDate = medicationsArray[realIndex].nextDose
            UIApplication.shared.scheduleLocalNotification(notification)
            
            
            
            medicationsArray = medicationsArray.sorted { $0.nextDose.compare($1.nextDose) == .orderedAscending }
            
            let medicationsData = NSKeyedArchiver.archivedData(withRootObject: medicationsArray)
            UserDefaults.standard.set(medicationsData, forKey: "medications")
            self.medicationsTable.setEditing(false, animated: true)
            reloadInfo()
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var containerArray:[Medication] = arrangedArray[currentTitles[indexPath.section].lowercased()]!
        _ = containerArray[indexPath.row]
        
        
        
        let logDosage = UITableViewRowAction(style: .normal, title: "    Log Dosage     ") { action, index in
            
            //self.addToCalendarButtonTapped(indexPath.row, array: selectedArray)
            
            self.logDosage(indexPath: indexPath)
            
        }
        
        logDosage.backgroundColor = UIColor(netHex: 0x5D73FD)
        //logDosage.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellLogDosage")!)
        
        let trash = UITableViewRowAction(style: .normal, title: "    Delete     ") { action, index in
            print("trash button tapped")
            
            self.deleteMedication(index: indexPath.row, array: containerArray)
            
        }
        
        trash.backgroundColor = UIColor(netHex: 0xDA1A4B)
        //trash.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellTrash")!)
        
        
        return [trash, logDosage]
        

    }
    
    func deleteMedication (index: Int, array: [Medication]) {
        
        let alertVC = UIAlertController(title: "Delete Medication", message: "Would you like to delete this medication?", preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let medToRemove = self.medicationsArray[self.medicationsArray.index(of: array[index])!]
            self.medicationsArray.remove(at: self.medicationsArray.index(of: array[index])!)
            
            for notif in UIApplication.shared.scheduledLocalNotifications! {
                if let firedate = notif.fireDate {
                    if firedate == medToRemove.nextDose {
                        UIApplication.shared.cancelLocalNotification(notif)
                    }
                }
            }
            
            let medicationData = NSKeyedArchiver.archivedData(withRootObject: self.medicationsArray)
            UserDefaults.standard.set(medicationData, forKey: "medications")
            
            self.medicationsTable.setEditing(false, animated: true)
            self.reloadInfo()
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        //alertVC.view.tintColor = UIColor.redColor()
        alertVC.addAction(dismissAction)
        alertVC.addAction(deleteAction)
        // alertVC.view.tintColor = UIColor.redColor()
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        })
        
        //alertVC.view.tintColor = hexColor(0x1F91F0)
    }
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    func integerInterval(index:Int, date:Date) -> Date {
        
        let mytime = NSTimeZone.local
        var calendar = NSCalendar.current
        calendar.timeZone = mytime
        
        let intText = medicationsArray[index].requiredIntervals
        var intNum = intText.components(separatedBy: " ")
        var timeInterval = DateComponents()
        
        switch intNum[2] {
        case "minutes":
            timeInterval.minute = Int(intNum[1])!
        case "hours":
            timeInterval.hour = Int(intNum[1])!
        case "days":
            timeInterval.day = Int(intNum[1])!
        case "weeks":
            timeInterval.day = Int(intNum[1])! * 7
        case "months":
            timeInterval.month = Int(intNum[1])!
        case "years":
            timeInterval.year = Int(intNum[1])!
        default:
            break;
        }
        
        let resultDate = calendar.date(byAdding: timeInterval, to: date)
        
        
        return resultDate!
    }
    
    func checkNewDoseRequirement(nextDate:Date) -> Date {
        
        let mytime = NSTimeZone.local
        var calendar = NSCalendar.current
        calendar.timeZone = mytime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        //var sleepTime = Date()
        //var wakeUpTime = Date()
        
        
        /*if let userSleep = UserDefaults.standard.object(forKey: "userSleep") as? String {
            sleepTime = stringToDate(dateString: userSleep)
        }
        
        if let userWake = UserDefaults.standard.object(forKey: "userWakeUp") as? String {
            wakeUpTime = stringToDate(dateString: userWake)
        } else {
            
        }*/
        
        
        let sleepHour = 21//NSCalendar.current.component(.hour, from: sleepTime)
        let sleepMin = 0//NSCalendar.current.component(.minute, from: sleepTime)
        
        let wakeHour = 9//NSCalendar.current.component(.hour, from: wakeUpTime)
        let wakeMin = 0//NSCalendar.current.component(.minute, from: wakeUpTime)
        
        let dateHour = NSCalendar.current.component(.hour, from: nextDate)
        let dateMinute = NSCalendar.current.component(.minute, from: nextDate)
        let dateDay = NSCalendar.current.component(.day, from: nextDate)
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date())
        
        
        var newDate = Date()
        
        
        
        if (((dateHour == sleepHour) && (dateMinute > sleepMin)) || (dateHour > sleepHour)) && ((dateHour <= 23) && (dateMinute <= 59)){
            
            _ = NSCalendar.current
            var currentComponents = calendar.dateComponents([.year, .day, .hour, .minute], from: Date())
            
            print("day is " + "\(String(describing: components.day))")
            
            print("day is " + "\(dateDay)")
            
            print(dateFormatter.string(from: newDate))
            
            currentComponents.day! += 1
            currentComponents.hour = wakeHour
            currentComponents.minute = wakeMin
            
            newDate = calendar.date(from: currentComponents)!
            return newDate
            
        } else if (dateHour < wakeHour) {
            
            _ = NSCalendar.current
            var currentComponents = calendar.dateComponents([.year, .day, .hour, .minute], from: Date())
            
            if currentComponents.hour! < 24 {
                
                currentComponents.day! += 1
                currentComponents.hour = wakeHour
                currentComponents.minute = wakeMin
                
            } else {
                
                currentComponents.hour = wakeHour
                currentComponents.minute = wakeMin
                
            }
            
            newDate = calendar.date(from: currentComponents)!
            return newDate
            
        } else {
            return nextDate
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var containerArray:[Medication] = arrangedArray[currentTitles[indexPath.section].lowercased()]!
        let medicationSelected = containerArray[indexPath.row]
        let selectedMedicationIndex = medicationsArray.index(of: medicationSelected)
        
        let button = UIButton()
        button.tag = selectedMedicationIndex!
        
        self.performSegue(withIdentifier: "viewMedication", sender: button)
    }
    
    func stringToDate(dateString:String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: dateString)!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMedication" {
            let object: UIButton = sender as! UIButton
            let destVC = segue.destination as! ViewMedicationViewController
            destVC.receivedMedication = medicationsArray[object.tag]
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
    
    
}
