//
//  FavouritesViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 3/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MapKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedIndex = Int()
    var favouritesArray = [Clinic]()
    
    @IBOutlet weak var favouritesTable: UITableView!
    
    @IBOutlet weak var noFavouritesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favouritesTable.tableFooterView = UIView()
        self.favouritesTable.backgroundColor = UIColor.groupTableViewBackground
        self.title = "Favourites"
        self.reloadInfo()
        
        if favouritesArray.count == 0 {
            noFavouritesView.isHidden = false
        } else {
            noFavouritesView.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! clinicTableCell
        cell.clinicName.text = favouritesArray[indexPath.row].name
        cell.locationLabel.text = favouritesArray[indexPath.row].location
        return cell
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVc: SelectedClinicViewController = segue.destination as! SelectedClinicViewController
        
        destVc.receivedClinic = favouritesArray[selectedIndex]
        destVc.favourite = true
        
        let latitude = CLLocationDegrees(favouritesArray[selectedIndex].latitude)
        let longitude = CLLocationDegrees(favouritesArray[selectedIndex].longitude)
        
        destVc.receivedCoordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "loadFavourite", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func reloadInfo() {
        
        let faveData = UserDefaults.standard.object(forKey: "favourites") as? NSData
        
        if let faveData = faveData {
            
            favouritesArray = NSKeyedUnarchiver.unarchiveObject(with: faveData as Data) as! [Clinic]
            
        }
        
        self.favouritesTable.reloadData()

    }
    
    func share (index: Int) {
        
        let shareName = favouritesArray[index].name
        let shareLocation = favouritesArray[index].location
        let shareNumber = favouritesArray[index].phone
        let shareText = "I just located this medical clinic on Medyc:\n\(shareName) at \(shareLocation)\n\(shareNumber)"
        
        let shareItems:Array = [shareText]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    func favourite (index: Int) {
        
        let favesData = UserDefaults.standard.object(forKey: "favourites") as? NSData
        if let favouritesData = favesData {
            favouritesArray = (NSKeyedUnarchiver.unarchiveObject(with: favouritesData as Data) as? [Clinic])!
        } else {
            
            let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouritesArray)
            UserDefaults.standard.set(favouritesData, forKey: "favourites")
            
        }
       
        favouritesArray.remove(at: index)
        
        let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouritesArray)
        
        UserDefaults.standard.set(favouritesData, forKey: "favourites")
        //defaults.setObject(favouritesData, forKey: "favourites")
        
        reloadInfo()
        //clinicTableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "    Share     ") { action, index in
            self.share(index: indexPath.row)
        }
        
        share.backgroundColor = UIColor(netHex: 0x5D73FD)
        //share.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellShare")!)
        
        let favorite = UITableViewRowAction(style: .normal, title: "    Remove     ") { action, index in
            print("favorite button tapped")
            
            //if self.favouriteClinics.count == 2 {
            
            // if let appMode = UserDefaults.standard.objectForKey("appMode") as? String {
            //if appMode == "free" {
            
            //    self.selectedIndex = indexPath.row
            //self.presentInAppAlert("Upgrade to Medyc Premium", description: "To favourite more clinics, you require Medyc Premium. Would you like to upgrade?")
            
            // } else if appMode == "premium" {
            self.favourite(index: indexPath.row)
            //}
            //  }
            
            // } else {
            //     self.favourite(indexPath.row)
            // }
            
        }
        favorite.backgroundColor = UIColor(netHex: 0xDA1A4B)
        
        //favorite.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellFavourites")!)
        
        
        return [favorite, share]
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //
    }
}
