//
//  ProfileViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 4/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var settingsHeadings = ["profile", "settings"]
    //var settingsDict:[String:[String]] = ["profile":["Edit Profile", "Health Care"], "medical":["Medical History", "Results", "Health Tracker"], "settings":["Privacy", "Help", "Rate Medyc"], "logout":["Logout"]]
    var settingsDict:[String:[String]] = ["profile":["Edit Profile", "Health Care"], "settings":["Help", "Rate Medyc"]]
    
    //var settingsValueDict:[String:[String]] = ["profile":["Mazen Kourouche", ""], "medical":["", "", ""], "settings":["None", "", ""], "logout":[""]]
    var settingsValueDict:[String:[String]] = ["profile":["", "", ""], "settings":["", ""]]
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Profile"
        self.settingsTable.tableFooterView = UIView()
        self.settingsTable.backgroundColor = UIColor.groupTableViewBackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsHeadings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var identifier = (settingsDict[settingsHeadings[indexPath.section]]?[indexPath.row])!
        
        if identifier == "Help" {
            self.performSegue(withIdentifier: "helpWeb", sender: nil)
        } else if (identifier == "Rate Medyc") {
            let url = URL(string: "https://itunes.apple.com/au/app/medyc/id1084202865?mt=8")!
            UIApplication.shared.openURL(url)
            
        } else {
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = settingsDict[settingsHeadings[indexPath.section]]?[indexPath.row]
        cell.detailTextLabel?.text = settingsValueDict[settingsHeadings[indexPath.section]]?[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsDict[settingsHeadings[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? WebViewController {
            destVC.receivedURL = "http://www.mazenkourouche.com/medyc"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
