//
//  MedicalHistoryViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 5/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MessageUI

class MedicalHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var medicalHistoryTable: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var sectionTitles = ["Personal Details", "Emergency Contact", "Health Care", "Medical Details"]
    var sectionArrays: [String:[String]] = ["Personal Details":["First Name", "Last Name", "Address", "Phone (h)", "Phone (m)", "Gender", "Date of Birth", "Height", "Weight"], "Emergency Contact":["First Name", "Last Name", "Phone (h)", "Phone (m)", "Relationship"], "Health Care":["Doctor's Name", "Phone (doctor)", "Health Care Number", "Health Fund Name", "Health Fund Number"], "Medical Details":["Blood Type", "Accepts Transfusions", "Allergies", "Medical Conditions", "Regular Medications"]]
    
    var textfieldsDict: [String:[UITextField]] = ["Personal Details":[UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField()], "Emergency Contact":[UITextField(), UITextField(), UITextField(), UITextField(), UITextField()], "Health Care":[UITextField(), UITextField(), UITextField(), UITextField(), UITextField()], "Medical Details":[UITextField(), UITextField(), UITextField(), UITextField(), UITextField()]]
    
    
    var placeholders: [String:[String]] = ["Personal Details":["First Name", "Last Name", "Address", "Phone (h)", "Phone (m)", "Gender", "Date of Birth", "Height", "Weight"], "Emergency Contact":["First Name", "Last Name", "Phone (h)", "Phone (m)", "Relationship"], "Health Care":["Doctor's Name", "Phone (doctor)", "Health Care Number", "Health Fund Name", "Health Fund Number"], "Medical Details":["Blood Type", "Accepts Transfusions", "Allergies", "Medical Conditions", "Regular Medications"]]
    
    var values:[String:[String:String]] = ["Personal Details":["userFirstName":"", "userLastName":"", "userAddress":"", "userPhoneH":"", "userPhoneM":"", "userGender":"", "userDOB":"", "userHeight":"", "userWeight":""], "Emergency Contact":["emergencyFirstName":"", "emergencyLastName":"", "emergencyPhoneH":"", "emergencyPhoneM":"", "emergencyRelationship":""], "Health Care":["healthDocName":"", "healthDocPhone":"", "healthCareNo":"", "healthFundName":"", "healthFundNo":""], "Medical Details":["userBloodType":"", "userAcceptsTrans":"", "userAllergies":"", "userConditions":"", "userMedications":""]]
    
    var defaultsKeys = ["Personal Details":["userFirstName", "userLastName", "userAddress", "userPhoneH", "userPhoneM", "userGender", "userDOB", "userHeight", "userWeight"], "Emergency Contact":["emergencyFirstName", "emergencyLastName", "emergencyPhoneH", "emergencyPhoneM", "emergencyRelationship"], "Health Care":["healthDocName", "healthDocPhone", "healthCareNo", "healthFundName", "healthFundNo"], "Medical Details":["userBloodType", "userAcceptsTrans", "userAllergies", "userConditions", "userMedications"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicalHistoryTable.delegate = self
        medicalHistoryTable.dataSource = self
        medicalHistoryTable.tableFooterView = UIView()
        medicalHistoryTable.backgroundColor = UIColor.groupTableViewBackground
        self.saveButton.isEnabled = false
        self.title = "Medical History"
        
        self.retrieveValues()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArrays[sectionTitles[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TextfieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextfieldTableViewCell
        
        cell.titleLabel.text = sectionArrays[sectionTitles[indexPath.section]]?[indexPath.row]
        cell.inputTextfield.placeholder = placeholders[sectionTitles[indexPath.section]]?[indexPath.row]
        
        var sectionTitle = sectionTitles[indexPath.section]
        var key = defaultsKeys[sectionTitle]?[indexPath.row]
        
        var value = values[sectionTitle]?[key!]
        
        //print(key + " " + value + " " + sectionTitle + " ")
        print("Key " + key!)
        print("Value " + value!)
        cell.inputTextfield = textfieldsDict[sectionTitle]![indexPath.row]
        
        cell.inputTextfield.delegate = self
        cell.inputTextfield.addTarget(self, action: #selector(EditProfileViewController.changesMade), for: .editingChanged)
        cell.inputTextfield.addTarget(self, action: #selector(MedicalHistoryViewController.changesMade), for: .editingChanged)
        
        //if textfieldsDict[sectionTitles[indexPath.section]]?[indexPath.row] == nil {
         //  textfieldsDict[sectionTitles[indexPath.section]]?[indexPath.row] = cell.inputTextfield
        //}
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    
    func changesMade() {
        
        for title in self.sectionTitles {
            
            for (index, key) in (defaultsKeys[title]?.enumerated())! {
                
                if values[title]?[key] != textfieldsDict[title]?[index].text {
                    values[title]?[key] = textfieldsDict[title]?[index].text
                    self.saveButton.isEnabled = true
                    return
                }
            }
            
        }
        
        self.saveButton.isEnabled = false
        
        return
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }


    func retrieveValues() {
        
        for title in sectionTitles {
            for (index, key) in defaultsKeys[title]!.enumerated() {
                if let retrievedValue = UserDefaults.standard.object(forKey: key) as? String {
                    
                    textfieldsDict[title]![index].text = retrievedValue
                    
                    values[title]?[key] = retrievedValue
                    
                }
            }
        }
        
        self.medicalHistoryTable.reloadData()
        
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        saveToDefaults()
        
    }
    
    func saveToDefaults() {
        for title in sectionTitles {
            for (index, key) in (defaultsKeys[title]?.enumerated())! {
                print("-----------")
                print("key " + key)
                print("value " + (textfieldsDict[title]?[index].text)!)
                UserDefaults.standard.set((textfieldsDict[title]?[index].text)!, forKey: key)
            }
        }
        
        //check if theres a passcode
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        //saveToDefaults()
        DispatchQueue.main.async {
            self.sendEmail()
        }
        
    }
    
    func sendEmail() {
        
        //
        
        var composer = MedicalFormComposer()
        if let invoiceHTML = composer.renderForm() {
            
            composer.exportHTMLContentToPDF(HTMLContent: invoiceHTML)
            
            if MFMailComposeViewController.canSendMail() {
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.mailComposeDelegate = self
                mailComposeViewController.setSubject("Medical History - Mazen Kourouche")
                
                var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
                
                var pdfFilename = "MedicalFormMedyc.pdf"
                docURL = docURL?.appendingPathComponent(pdfFilename)
                
                do {
                    try mailComposeViewController.addAttachmentData(Data(contentsOf: docURL!), mimeType: "application/pdf", fileName: "Medical History")
                    
                    
                    present(mailComposeViewController, animated: true, completion: nil)
                    
                } catch {
                    
                }
            }
            
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
        
    
    
}
