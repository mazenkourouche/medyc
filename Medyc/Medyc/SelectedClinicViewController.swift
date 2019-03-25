//
//  SelectedClinicViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MapKit

class SelectedClinicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var favourite = false
    var cellHeights = [100, 260]
    var receivedClinic = Clinic()
    var receivedCoordinates = CLLocationCoordinate2D()
    var cellInfo = [String:String]()
    var cellTypes = [String]()
    var cellIcons = [String:AnyObject]()
    
    var centreType = String()
    
    var favouritesArray = [Clinic]()
    
    @IBOutlet weak var infoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        
        infoTable.tableFooterView = UIView()
        infoTable.backgroundColor = UIColor.groupTableViewBackground
        infoTable.tableFooterView?.backgroundColor = UIColor.groupTableViewBackground
        setupCells()
        
        self.infoTable.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if favourite {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellHeights.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return CGFloat(cellHeights[indexPath.row])
        } else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        switch indexPath.row {
        case 0:
            
            let cell:ClinicInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! ClinicInfoTableViewCell
            
            cell.clinicName.text = receivedClinic.name
            cell.clinicType.text = receivedClinic.suburb
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! ClinicMapTableViewCell
            
            let center = CLLocationCoordinate2D(latitude: receivedCoordinates.latitude, longitude: receivedCoordinates.longitude)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            
            let annotation = MKPointAnnotation()
            annotation.title = self.receivedClinic.name
            annotation.subtitle = self.receivedClinic.location
            annotation.coordinate = (receivedCoordinates)
            
            cell.clinicMap.addAnnotation(annotation)
            
            cell.clinicMap.showsUserLocation = true
            cell.clinicMap.setRegion(region, animated: true)
            
            cell.clinicMap.layer.cornerRadius = 8
            cell.directionsButton.layer.cornerRadius = 8
            cell.selectionStyle = .none
            
            return cell
            
        
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! optionTableViewCell
            cell.infoLabel.text = cellInfo[cellTypes[indexPath.row]]
            cell.icon.image = UIImage(named: cellTypes[indexPath.row] + "Icon")
            cell.selectionStyle = .none
            return cell
        }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! optionTableViewCell
            cell.infoLabel.text = "Add to Favourites"
            cell.icon.image = UIImage(named: "heartIcon")
            cell.selectionStyle = .none
            cell.infoLabel.textColor = UIColor(netHex: 0x576BF5)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row > 1 {
                selectFunction(cellType: cellTypes[indexPath.row])
            }
        } else {
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return " "
        }
    }
    
    func setupCells () {
        
        cellTypes.append("info")
        cellTypes.append("map")
        
        if receivedClinic.phone != "" {
            cellTypes.append("phone")
            cellInfo["phone"] = receivedClinic.phone
            print(receivedClinic.phone)
            cellIcons["phone"] = UIImage(named: "phoneIcon")
            cellHeights.append(50)
        }
        
        if receivedClinic.url != "" {
            
            cellTypes.append("website")
            cellInfo["website"] =  receivedClinic.url
            print(receivedClinic.url)
            cellIcons["website"] = UIImage(named: "websiteIcon")
            cellHeights.append(50)
        }

        if receivedClinic.location != "" {
            
            let location = receivedClinic.formattedLocation
            let formattedLocation = location.replacingOccurrences(of: ", ", with: "\n")
            print(formattedLocation)
            cellTypes.append("share")
            cellInfo["share"] = formattedLocation
            cellIcons["share"] = UIImage(named: "shareIcon")
            cellHeights.append(90)
        }

    }

    @IBAction func directionsTapped(_ sender: Any) {
        
        directionsSelected()
    }
    
    func callSelected () {
        
        print("Call")
        
        //var numberToCallArray = self.receivedClinic.phone.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        
        let numberToCall = self.receivedClinic.phone
        
        displayPhoneAlert(title: "Call " + self.receivedClinic.phone, message: "Would you like to proceed?", number: numberToCall)
        
    }
    
    func directionsSelected () {
        createDirections(address: self.receivedClinic.location)
    }
    
    func websiteSelected() {
        self.performSegue(withIdentifier: "showWebsite", sender: nil)
    }
    
    func shareSelected() {
        share()
    }
    
    func selectFunction(cellType: String) {
        
        var selector = NSSelectorFromString("")
        
        switch cellType {
        case "map":
            selector = NSSelectorFromString("directionsSelected")
        case "phone":
            selector = NSSelectorFromString("callSelected")
        case "website":
            selector = NSSelectorFromString("websiteSelected")
        case "share":
            selector = NSSelectorFromString("shareSelected")
        default:
            break;
        }
        
        self.perform(selector)
    }
    
    func createDirections (address: String) {
        let geocoder = CLGeocoder()
        
        /*var directionsActivityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
         directionsActivityIndicator.activityIndicatorViewStyle = .Gray
         self.view.addSubview(directionsActivityIndicator)
         directionsActivityIndicator.startAnimating()
         */
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            // directionsActivityIndicator.stopAnimating()
            
            if let placemark = placemarks?[0] as CLPlacemark? {
                
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                
                mapItem.name = "Directions"
                let alertView = UIAlertController(title: "Directions", message: "How would you like to get there?", preferredStyle: UIAlertControllerStyle.alert)
                
                
                alertView.addAction(UIAlertAction(title: "Drive", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    DispatchQueue.main.async() {
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }))
                
                alertView.addAction(UIAlertAction(title: "Walk", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                    DispatchQueue.main.async() {
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }))
                if #available(iOS 9.0, *) {
                    alertView.addAction(UIAlertAction(title: "Public Transport", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit]
                        DispatchQueue.main.async() {
                            
                            mapItem.openInMaps(launchOptions: launchOptions)
                            
                        }
                    }))
                }
                
                alertView.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alertView, animated: true, completion: nil)
                alertView.view.tintColor = UIColor(netHex: 0x1F91F0)
            }
        }
        
    }
    
    
    func share() {
        let shareName = receivedClinic.name
        let shareLocation = receivedClinic.location
        let sharePhone = receivedClinic.phone
        
        let shareText = "I just located this medical clinic on Medyc: \n\(shareName) at \(shareLocation)\n\(sharePhone)"
        
        let shareItems:Array = [shareText]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func displayPhoneAlert (title:String, message:String, number: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismiss:UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        let correctedNumber = number.replacingOccurrences(of: " ", with: "").addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if let url = NSURL(string: "tel:" + correctedNumber) {
            let callPhone = UIAlertAction(title: "Call", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                UIApplication.shared.openURL(url as URL)
            }
            alert.addAction(callPhone)
            
        } else {
            alert = UIAlertController(title: "Invalid Number", message: "Can not call this location", preferredStyle: .alert)
        }
        
        
        alert.addAction(dismiss)
        
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor(netHex: 0x1F91F0)
    }
    
    func saveData() {
        
        favouritesArray.append(receivedClinic)
        
        let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouritesArray)
        UserDefaults.standard.set(favouritesData, forKey: "favourites")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func retrieveData() {
        if UserDefaults.standard.object(forKey: "favourites") == nil {
            let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouritesArray)
            UserDefaults.standard.set(favouritesData, forKey: "favourites")
            
        } else {
            
            let favouritesData = UserDefaults.standard.object(forKey: "favourites") as? NSData
            
            
            if let favouritesData = favouritesData {
                favouritesArray = NSKeyedUnarchiver.unarchiveObject(with: favouritesData as Data) as! [Clinic]
                
                for fave in favouritesArray {
                    print(fave.name)
                    print(receivedClinic.name)
                    if fave.name == receivedClinic.name {
                        favourite = true
                        return
                    }
                }
               
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! WebViewController
        destVC.receivedURL = self.receivedClinic.url
    }
    
    

}
