//
//  EditProfileViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 5/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var profileTable: UITableView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var profileHeadings = ["First Name", "Last Name", "Email"]
    
    var profileDict = ["First Name": "", "Last Name": "", "Email": ""]
    
    var textfieldsDict = ["First Name": UITextField(), "Last Name": UITextField(), "Email": UITextField()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTable.delegate = self
        profileTable.dataSource = self
        profileTable.tableFooterView = UIView()
        profileTable.backgroundColor = UIColor.groupTableViewBackground
        self.saveButton.isEnabled = false
        self.title = "Edit Profile"
        
        if let profileInfoDict = UserDefaults.standard.object(forKey: "profileInfoDict") as? [String: String] {
            profileDict = profileInfoDict
            self.profileTable.reloadData()
        } else {
            UserDefaults.standard.set(profileDict, forKey: "profileInfoDict")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileHeadings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FormTableViewCell
        cell.formEntryTextfield.text = profileDict[profileHeadings[indexPath.row]]
        cell.formEntryTextfield.placeholder = profileHeadings[indexPath.row]
        cell.formEntryTextfield.delegate = self
        cell.formEntryTextfield.addTarget(self, action: #selector(EditProfileViewController.changesMade), for: .editingChanged)
        textfieldsDict[profileHeadings[indexPath.row]] = cell.formEntryTextfield
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        self.saveButton.isEnabled = false
        
        return
        
    }
   
    @IBAction func saveChanges(_ sender: Any) {
        for heading in self.profileHeadings {
            
            profileDict[heading]! = (textfieldsDict[heading]?.text!)!
            
        }
        
        UserDefaults.standard.set(profileDict, forKey: "profileInfoDict")
        self.navigationController?.popViewController(animated: true)
        
    }
}
