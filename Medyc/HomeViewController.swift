//
//  HomeViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 27/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextMap: MKMapView!
    
    @IBOutlet weak var laterTable: UITableView!
    
    @IBOutlet weak var greetingIcon: UIImageView!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var shadowViwew: UIView!
    
    var laterArray = [TodayItem]()
    var appointmentsArray = [Appointment]()
    var medicationsArray = [Medication]()
    
    @IBOutlet weak var nextStatusLabel: UILabel!
    
    @IBOutlet weak var nextTitleLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var nextInfoLabel: UILabel!
    
    @IBOutlet weak var whatsNextHeading: UILabel!
    @IBOutlet weak var furtherToday: UILabel!
    
    var empty = false
    
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var appointmentButton: UIButton!
    @IBOutlet weak var medicationButton: UIButton!
    
    var buttonSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupArray()
        setupGreetings()
        
        todayView.layer.cornerRadius = 5
        todayView.layer.masksToBounds = true

        shadowViwew.layer.masksToBounds = false
        shadowViwew.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowViwew.layer.shadowColor = UIColor(netHex: 0x576BF5).cgColor
        shadowViwew.layer.shadowOpacity = 0.3
        shadowViwew.layer.shadowRadius = 10
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.tintColor = UIColor(netHex: 0x576BF5)
       
        locateButton.layer.cornerRadius = locateButton.frame.height/6
        appointmentButton.layer.cornerRadius = locateButton.frame.height/6
        medicationButton.layer.cornerRadius = locateButton.frame.height/6
        
        locateButton.addTarget(self, action: #selector(HomeViewController.buttonPressedCall(sender:)), for: .touchUpInside)
        appointmentButton.addTarget(self, action: #selector(HomeViewController.buttonPressedCall(sender:)), for: .touchUpInside)
        medicationButton.addTarget(self, action: #selector(HomeViewController.buttonPressedCall(sender:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! TodayTableViewCell
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let datestring = formatter.string(from: laterArray[indexPath.row].date)
        
        cell.timeLabel.text = datestring
        cell.nameLabel.text = laterArray[indexPath.row].name
        
        switch laterArray[indexPath.row].type {
        case "appointment":
            cell.icon.image = #imageLiteral(resourceName: "noAppointmentsIcon")
        case "medication":
            cell.icon.image = #imageLiteral(resourceName: "noMedicationssIcon")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    func setupArray() {
        
        locateButton.isHidden = true
        appointmentButton.isHidden = true
        medicationButton.isHidden = true
        
        laterArray.removeAll()
        appointmentsArray.removeAll()
        medicationsArray.removeAll()
        
        let appointmentsData = UserDefaults.standard.object(forKey: "appointments") as? NSData
        let medicationsData = UserDefaults.standard.object(forKey: "medications") as? NSData
        
        
        if let appointmentsData = appointmentsData {
            appointmentsArray = NSKeyedUnarchiver.unarchiveObject(with: appointmentsData as Data) as! [Appointment]
        }
        
        if let medicationsData = medicationsData {
            medicationsArray = NSKeyedUnarchiver.unarchiveObject(with: medicationsData as Data) as! [Medication]
        }
        
        
        for (index, appointment) in appointmentsArray.enumerated() {
            
            if index < 3 {
                let newItem = TodayItem(name: appointment.name, date: appointment.date, index: index, type: "appointment")
                
                if appointment.date.isGreaterThanDate(dateToCompare: Date()) {
                    laterArray.append(newItem)
                }
                
            } else {
                break
            }
            
        }
        
        if laterArray.count > 0 {
            for (index, medication) in medicationsArray.enumerated() {
                
                if index < 3 {
                    if (laterArray.last?.date.isGreaterThanDate(dateToCompare: medication.nextDose))! {
                        
                        let newItem = TodayItem(name: medication.medName, date: medication.nextDose, index: index, type: "medication")
                        
                        if medication.nextDose.isGreaterThanDate(dateToCompare: Date()) {
                            laterArray.insert(newItem, at: 0)
                        }
                        
                        if laterArray.count > 3 {
                            laterArray.removeLast()
                        }
                        
                    }
                } else {
                    break
                }
            }
        } else {
            
            for (index, medication) in medicationsArray.enumerated() {
                
                if index < 3 {
                    let newItem = TodayItem(name: medication.medName, date: medication.nextDose, index: index, type: "medication")
                    
                    if medication.nextDose.isGreaterThanDate(dateToCompare: Date()) {
                        laterArray.append(newItem)
                    }
                    
                } else {
                    break
                }
                
            }
            
        }
        
        laterArray = self.laterArray.sorted(by: {$0.date.compare($1.date as Date) == .orderedAscending})
        
        
        if let nextItem = laterArray.first {
            
            laterArray.removeFirst()
            
            laterTable.reloadData()
            
            reloadNextView(item: nextItem)
            
            print((laterArray.count))
        } else {
           noNewActivities()
        }
        
    }
    
    func reloadNextView(item: TodayItem) {
        
        self.nextTitleLabel.text = item.name
        self.nextStatusLabel.text = getNextStatus(date: item.date)
        self.nextDateLabel.text = dateToString(date: item.date)
        
        if item.type == "appointment" {
            self.nextInfoLabel.text = appointmentsArray[item.index].location
        } else {
            self.nextInfoLabel.text = "\(medicationsArray[item.index].dailyDosages - medicationsArray[item.index].dosesTakenToday) remaining"
        }
        
    }
    
    
    
    func noNewActivities() {
        self.todayView.isHidden = true
        self.shadowViwew.isHidden = true
        whatsNextHeading.isHidden = true
        furtherToday.isHidden = true
        empty = true
        
        locateButton.isHidden = false
        appointmentButton.isHidden = false
        medicationButton.isHidden = false
    }
    
    func getNextStatus(date: Date) -> String {
        return "TODAY"
    }
    
    func dateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
        
    }
    
    
    func setupGreetings() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        _ = dayOfWeekString.uppercased()
        
     
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        _ = components.minute
        
        var greeting = ""
        
        if empty {
            greeting = "your schedule is currently empty."
            
        } else {
            greeting = "here's a quick start for you."
        }
        
        if hour >= 6 && hour < 12 {
            //Morning
            titleLabel.text = "Good morning, " + greeting
            greetingIcon.image = UIImage(named: "MorningIcon")
            
        } else if hour >= 12 && hour < 17 {
            //Afternoon
            titleLabel.text = "Good afternoon, " + greeting
            greetingIcon.image = UIImage(named: "AfternoonIcon")
            
        } else if hour >= 17 && hour <= 20 {
            //Evening
            titleLabel.text = "Good evening, " + greeting
            greetingIcon.image = UIImage(named: "EveningIcon")
            
        } else if hour > 20 || hour < 6 {
            //Night
            titleLabel.text = "Good night, " + greeting
            greetingIcon.image = UIImage(named: "NightIcon")
            
        }
        
    }
    
    func buttonPressedCall(sender: Any) {
        if let sender = sender as? UIButton {
            buttonSelected = true
            self.tabBarController?.selectedIndex = sender.tag
        }
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if buttonSelected {
            buttonSelected = false
            switch item.tag {
            case 1:
                print("")
            case 2:
               AppointmentsViewController().performSegue(withIdentifier: "addAppointment", sender: nil)
            case 3:
               MedicationsViewController().performSegue(withIdentifier: "addAppointment", sender: nil)
            default:
                break
            }
        }
    }
    
}
