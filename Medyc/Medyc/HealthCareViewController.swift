//
//  HealthCareViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 5/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class HealthCareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var healthCareTable: UITableView!
    
    var profileHeadings = ["Health Care Number", "Health Fund", "Health Fund Number"]
    
    //var profileDict = ["Health Care Number": "0123456789", "Health Fund": "HCF", "Health Fund Number": "023456789"]
    var profileDict = ["Health Care Number": "", "Health Fund": "", "Health Fund Number": ""]
    var placeholderDict = ["Health Care Number": "e.g 123456", "Health Fund": "e.g Body Cares", "Health Fund Number": "e.g 123456"]
    var textfieldsDict = ["Health Care Number": UITextField(), "Health Fund": UITextField(), "Health Fund Number": UITextField()]
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        healthCareTable.delegate = self
        healthCareTable.dataSource = self
        healthCareTable.tableFooterView = UIView()
        healthCareTable.backgroundColor = UIColor.groupTableViewBackground
        //self.saveButton.isEnabled = false
        self.title = "Health Care"
        // Do any additional setup after loading the view.
        
        if let healthcareDict = UserDefaults.standard.object(forKey: "healthcareDict") as? [String: String] {
            profileDict = healthcareDict
            self.healthCareTable.reloadData()
        } else {
            UserDefaults.standard.set(profileDict, forKey: "healthcareDict")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileHeadings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TextfieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextfieldTableViewCell
        cell.inputTextfield.text = profileDict[profileHeadings[indexPath.row]]
        cell.titleLabel.text = profileHeadings[indexPath.row]
        cell.inputTextfield.delegate = self
        cell.inputTextfield.placeholder = placeholderDict[profileHeadings[indexPath.row]]
        cell.inputTextfield.addTarget(self, action: #selector(HealthCareViewController.changesMade), for: .editingChanged)
        textfieldsDict[profileHeadings[indexPath.row]] = cell.inputTextfield
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    
    func changesMade() {
        
        for heading in self.profileHeadings {
            
            if profileDict[heading]! != textfieldsDict[heading]?.text! {
                
                self.saveButton.isEnabled = true
                
                return
            }
        }
        
        //self.saveButton.isEnabled = false
        //
        return
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        for heading in self.profileHeadings {
            
            profileDict[heading]! = (textfieldsDict[heading]?.text!)!
                
        }
            
        UserDefaults.standard.set(profileDict, forKey: "healthcareDict")
            self.navigationController?.popViewController(animated: true)
        
    }
    
    
    /*
    @IBAction func saveChanges(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }*/


    

}
