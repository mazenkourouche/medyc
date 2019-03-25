//
//  AddMedicationViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 24/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class AddMedicationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var cellTitles = ["Medication Name", "Number of Dosages", "Daily Dosages", "Intervals"]
    var cellSubtitles = ["Medication Name", "Total course", "Doses per day", "e.g Every 4 hours"]
    
    var receivedIndex = Int()
    var editMode = false
    
    var cellTextfields = [UITextField]()
    
    var nameTextfield = UITextField()
    var totalTextfield = UITextField()
    var intervalsTextfield = UITextField()
    var dailyTextfield = UITextField()
    
    var intervalPicker = UIPickerView()
    
    var selectedIntRow = Int()
    var selectedStringRow = Int()
    
    var expandedCells = [true, false, false, false]
    
    var intervalInt = [Int]()
    var intervalString = ["minutes", "hours", "days", "weeks", "months", "years"]
    
    var givenInt = Int()
    var givenString = String()
    
    var medicationsArray = [Medication]()
    
    var receivedInfo = ["", "", "", ""]
    
    @IBOutlet weak var medicationsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cellTextfields.append(nameTextfield)
        cellTextfields.append(totalTextfield)
        cellTextfields.append(intervalsTextfield)
        cellTextfields.append(dailyTextfield)
        
        medicationsTable.tableFooterView = UIView()
        
        let medicationsData = UserDefaults.standard.object(forKey: "medications") as? NSData
        if let medicationsData = medicationsData {
            medicationsArray = (NSKeyedUnarchiver.unarchiveObject(with: medicationsData as Data) as? [Medication])!
        }
        
        for i in 1 ... 60 {
            intervalInt.append(i)
        }
        
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
        
        givenInt = intervalInt[0]
        givenString = intervalString[0]
        
        if receivedInfo[0] == "" {
            self.title = "New Medication"
        } else {
            self.title = "Add Medication"
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if editMode {
            return 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextfieldTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = cellTitles[indexPath.row]
            cellTextfields[indexPath.row] = cell.inputTextfield
            cell.selectionStyle = .none
            cell.sideIcon.isHidden = false
            
            switch indexPath.row {
            case 0:
                cell.inputTextfield.autocapitalizationType = .words
                cell.sideIcon.isHidden = true
            case 1:
                cell.inputTextfield.keyboardType = .numberPad
            case 2:
                cell.inputTextfield.keyboardType = .numberPad
            case 3:
                cell.inputTextfield.inputView = intervalPicker
            
            default:
                break
            }
            
            cell.inputTextfield.text = self.receivedInfo[indexPath.row]
            cell.inputTextfield.placeholder = cellSubtitles[indexPath.row]
            
        case 1:
            cell.titleLabel.text = "Delete Medication"
            cell.inputTextfield.isHidden = true
            
            cell.titleLabel.textColor = .red
            cell.titleLabel.sizeToFit()
        default:
            break
        }
        
        print(cell.subviews.count)
        
        cell.inputTextfield.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cellTitles.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return intervalInt.count
        } else {
            return intervalString.count
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(intervalInt[row])
        } else {
            return intervalString[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            givenInt = intervalInt[row]
        } else if component == 1 {
            givenString = intervalString[row]
        }
        cellTextfields[3].text = "Every \(givenInt) \(givenString)"
        
        print(integerInterval())
    }
    

    func integerInterval() -> Date {
        
        let mytime = NSTimeZone.local
        var calendar = NSCalendar.current
        calendar.timeZone = mytime
        
        let intText = cellTextfields[3].text!
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
        
        let resultDate = calendar.date(byAdding: timeInterval, to: Date())
        
        //switch interv
        
        return resultDate! as Date
    }
    
    @IBAction func save(_ sender: Any) {
        
        if cellTextfields[0].text == "" || cellTextfields[1].text == "" || cellTextfields[2].text == "" || cellTextfields[3].text == "" {
            
            let alertVC = UIAlertController(title: "Missing Information", message: "Enter missing information and try again", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertVC.addAction(dismissAction)
            self.present(alertVC, animated: true, completion: nil)
            //      alertVC.view.tintColor = hexColor(0x1F91F0)
            
        } else {
            
            if editMode {
                self.medicationsArray.remove(at: receivedIndex)
            }
            
            let alertVC = UIAlertController(title: "Dosage Check", message: "Have you already taken your first dosage?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                let notification:UILocalNotification = UILocalNotification()
                notification.fireDate = self.integerInterval()
                UIApplication.shared.scheduleLocalNotification(notification)
                self.saveData(taken: true)
                
            })
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                let notification:UILocalNotification = UILocalNotification()
                notification.fireDate = NSDate() as Date
                UIApplication.shared.scheduleLocalNotification(notification)
                
                self.saveData(taken: false)
                
            })
            
            alertVC.addAction(yesAction)
            alertVC.addAction(noAction)
            
            self.present(alertVC, animated: true, completion: nil)
            //      alertVC.view.tintColor = UIColor(0x1F91F0)
            
            
        }

        
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(taken: Bool) {
        
        var newMedication = Medication()
        
        if taken {
            newMedication = Medication(medName: cellTextfields[0].text!, totalDosages: Int(cellTextfields[1].text!)!, dailyDosages: Int(cellTextfields[2].text!)!, requiredIntervals: cellTextfields[3].text!, dosesTakenToday: 1, dateLogged: NSDate().self as Date, nextDose: self.integerInterval(), medicationID: self.generateMedID())
        } else{
            newMedication = Medication(medName: cellTextfields[0].text!, totalDosages: Int(cellTextfields[1].text!)!, dailyDosages: Int(cellTextfields[2].text!)!, requiredIntervals: cellTextfields[3].text!, dosesTakenToday: 0, dateLogged: Date().self, nextDose: Date(), medicationID: self.generateMedID())
        }
        
        medicationsArray.append(newMedication)
        
        
        if cellTextfields[2].text == "" {
            cellTextfields[2].text = "1"
        }
        
        let medicationsData = NSKeyedArchiver.archivedData(withRootObject: self.medicationsArray)
        UserDefaults.standard.set(medicationsData, forKey: "medications")
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            cellTextfields[indexPath.row].becomeFirstResponder()
        } else {
            //delete
        }
    }


    func generateMedID() -> String {
        
        let currentCalendar = NSCalendar.current
        let currentComponents =
            currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        var IDString = "\(currentComponents.second!)" + "\(currentComponents.year!)" + "\(currentComponents.minute!)"
        IDString += "\(currentComponents.hour!)" + "\(currentComponents.day!)" + "\(currentComponents.month!)" + String(arc4random_uniform(100))
        
        return IDString
        
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
    
    
    
   
}
