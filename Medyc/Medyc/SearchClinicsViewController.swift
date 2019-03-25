//
//  NearbyViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MapKit

class SearchClinicsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    var mapView = MKMapView()
    
    var mapItemsFound = [MKMapItem]()
    
    var clinicsFound = [Clinic]()
    
    var annotations = [MKPointAnnotation]()
    
    var selectedIndex = Int()
    
    var locationsTable = UITableView()
    var locationTableBackground = UIView()
    
    var favouriteClinics = [Clinic]()
    
    @IBOutlet weak var sampleLocationTable: UITableView!
    
    @IBOutlet weak var mapGuide: UIView!
    
    @IBOutlet weak var locationsExpandeGuide: UIView!
    @IBOutlet weak var locationsNormalGuide: UIView!
    @IBOutlet weak var locationsMinimisedGuide: UIView!
    
    
    @IBOutlet weak var changeSearchView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var buttonShadow: UIView!
    
    var currentCategory = "General Practitioner"
    
    var selectingCategory = false
    
    var categoriesTable = UITableView()
    var listBackground = UIView()
    var listShadow = UIView()
    
    var swipeGesture = UIPanGestureRecognizer()
    
    var favouritesButton = UIButton()
    var favouritesIcon = UIImageView(image: #imageLiteral(resourceName: "heartIcon"))
    var favouritesLabel = UILabel()
    
    var categories = ["General practitioner", "Dentist", "Optometrist", "Gynecologist", "Psychologist", "Cardiologist", "Dermatologist", "Physiotherapist", "Podiatrist", "Psychiatrist"]
    
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(netHex: 0x576BF5)
        
        self.navigationItem.rightBarButtonItem = activityBarButtonItem
        activityIndicator.startAnimating()
        
        self.locationsTable = sampleLocationTable
        
        self.locationsTable.delegate = self
        self.locationsTable.dataSource = self
        
        favouritesButton.addTarget(self, action: #selector(NearbyViewController.goToFavourites), for: .touchUpInside)
        
        mapView.delegate = self
        
        changeSearchView.layer.cornerRadius = 8
        changeSearchView.layer.masksToBounds = true
        
        self.mapView.tintColor = UIColor(netHex: 0x576BF5)
        self.view.addSubview(mapView)
        
        self.view.addSubview(locationTableBackground)
        self.view.addSubview(locationsTable)
        //self.locationTableBackground.addSubview(locationsTable)
        self.view.addSubview(categoriesTable)
        self.view.addSubview(listShadow)
        self.view.addSubview(listBackground)
        self.locationTableBackground.addSubview(favouritesButton)
        self.locationTableBackground.addSubview(favouritesIcon)
        self.locationTableBackground.addSubview(favouritesLabel)
        
        self.categoriesTable.delegate = self
        self.categoriesTable.dataSource = self
        self.categoriesTable.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cellCat")
        
        //self.view.center = self.mapGuide.center
        
        self.mapView.userTrackingMode = .follow
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startMonitoringSignificantLocationChanges()
        
        
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        
        
        //locationsTable.isScrollEnabled = false
        
        swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(NearbyViewController.swipe(sender:)))
        swipeGesture.minimumNumberOfTouches = 1
        swipeGesture.maximumNumberOfTouches = 1
        
        
        let favesData = UserDefaults.standard.object(forKey: "favourites") as? Data
        if let favouritesData = favesData {
            favouriteClinics = (NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as? [Clinic])!
        } else {
            
            let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouriteClinics)
            UserDefaults.standard.set(favouritesData, forKey: "favourites")
            
        }
        
    }
    
    var initalSelected = false
    var initialTouchPoint = CGFloat()
    var guideView = UIView()
    
    func swipe(sender: UIPanGestureRecognizer) {
        
        let p:CGPoint = sender.location(in: self.view)
        //var center:CGPoint = CGPoint.zero
        var selectedView = UIView()
        
        if selectingCategory {
            self.changeCategory(UIButton())
        }
        
        switch locationTableBackground.frame.minY {
        case self.locationsMinimisedGuide.frame.minY:
            guideView = locationsMinimisedGuide
        case self.locationsNormalGuide.frame.minY:
            guideView = locationsNormalGuide
        case self.locationsExpandeGuide.frame.minY:
            guideView = locationsExpandeGuide
        default:
            break
        }
        
        switch sender.state {
        case .began:
            print("began")
            
            
            if let selected = view.hitTest(p, with: nil) {
                selectedView = selected
                //self.view.bringSubview(toFront: selectedView)
            }
            
        case .changed:
            
            if !initalSelected {
                initalSelected = true
                initialTouchPoint = p.y
            }
            
            //center = selectedView.center
            let distance = guideView.frame.minY + (p.y - initialTouchPoint)
            print("center" + "\(distance)")
            print("distance" + "\(distance)")
            print("p.y" + "\(p.y)")
            print("initial" + "\(initialTouchPoint)")
            
            if distance < self.locationsExpandeGuide.frame.minY {
                
            } else {
                locationTableBackground.frame.origin.y = distance
                locationsTable.frame.origin.y = distance + 60
            }
            
            
        case .ended:
            initalSelected = false
            
            //TODO - check for a full swip up or down
            
            if (self.locationTableBackground.frame.minY - self.guideView.frame.minY) > 20 {
                //minimise
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    if self.guideView == self.locationsExpandeGuide {
                        self.locationTableBackground.frame.origin.y = self.locationsNormalGuide.frame.minY
                        self.locationsTable.frame.origin.y = self.locationsNormalGuide.frame.minY + 60
                    } else {
                        self.locationTableBackground.frame.origin.y = self.locationsMinimisedGuide.frame.minY
                        self.locationsTable.frame.origin.y = self.locationsMinimisedGuide.frame.minY + 60
                    }
                    
                }, completion: { (finished) in
                    
                })
                
            } else if (self.locationTableBackground.frame.minY - self.guideView.frame.minY) < -20 {
                //maximise
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    if self.guideView == self.locationsMinimisedGuide {
                        self.locationTableBackground.frame.origin.y = self.locationsNormalGuide.frame.minY
                        self.locationsTable.frame.origin.y = self.locationsNormalGuide.frame.minY + 60
                    } else {
                        self.locationTableBackground.frame.origin.y = self.locationsExpandeGuide.frame.minY
                        self.locationsTable.frame.origin.y = self.locationsExpandeGuide.frame.minY + 60
                    }
                    
                }, completion: { (finished) in
                    
                })
                
            } else {
                //normal
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.locationTableBackground.frame.origin.y = self.guideView.frame.minY
                    self.locationsTable.frame.origin.y = self.guideView.frame.minY + 60
                    
                }, completion: { (finished) in
                    
                })
                
            }
            
            
        default:
            break
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == locationsTable {
            let placemark = mapItemsFound[indexPath.row].placemark
            
            
            //if mapView.selectedAnnotations.contains({$0 as! MKPointAnnotation == annotations[indexPath.row]}) {
            
            
            if indexPath.row == selectedIndex {
                self.performSegue(withIdentifier: "selectedClinicSegue", sender: nil)
            } else {
                selectedIndex = indexPath.row
                
                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude), span: mapView.region.span), animated: true)
                
                self.mapView.selectAnnotation(annotations[selectedIndex], animated: true)
                
            }
            
        } else {
            
            currentCategory = categories[indexPath.row]
            changeCategory(sender: UIButton())
            categoryLabel.text = currentCategory
            
            //add refresh of map
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseId = "test"
        
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        anView?.image = #imageLiteral(resourceName: "annotationImage")
        
        return anView
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFavourites" {
            
        } else {
            let destVc: SelectedClinicViewController = segue.destination as! SelectedClinicViewController
            
            destVc.receivedClinic = clinicsFound[selectedIndex]
            destVc.receivedCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(clinicsFound[selectedIndex].latitude)!, longitude: CLLocationDegrees(clinicsFound[selectedIndex].longitude)!)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.mapView.frame.size = self.mapGuide.frame.size
        self.mapGuide.frame.origin = self.mapGuide.frame.origin
        
        categoriesTable.backgroundColor = UIColor.clear
        listBackground.backgroundColor = .white
        listShadow.backgroundColor = .white
        locationTableBackground.backgroundColor = .white
        
        self.categoriesTable.alpha = 0
        self.categoriesTable.separatorColor = UIColor(netHex: 0xE7E6E6)
        
        self.listBackground.alpha = 0
        self.listShadow.alpha = 0
        
        self.view.bringSubview(toFront: listShadow)
        self.view.bringSubview(toFront: listBackground)
        self.view.bringSubview(toFront: categoriesTable)
        self.view.bringSubview(toFront: buttonShadow)
        self.view.bringSubview(toFront: changeSearchView)
        self.view.bringSubview(toFront: locationTableBackground)
        self.view.bringSubview(toFront: locationsTable)
        
        buttonShadow.layer.masksToBounds = false
        buttonShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonShadow.layer.shadowColor = UIColor.black.cgColor
        buttonShadow.layer.shadowOpacity = 0.23
        buttonShadow.layer.shadowRadius = 8
        
        listBackground.layer.cornerRadius = 8
        listBackground.layer.masksToBounds = true
        
        listShadow.layer.masksToBounds = false
        listShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        listShadow.layer.shadowColor = UIColor.black.cgColor
        listShadow.layer.shadowOpacity = 0.23
        listShadow.layer.shadowRadius = 8
        changeSearchView.layer.cornerRadius = 5
        changeSearchView.layer.masksToBounds = true
        
        self.categoryLabel.text = currentCategory
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        locationTableBackground.frame.size = self.locationsExpandeGuide.frame.size
        locationTableBackground.frame = CGRect(origin: CGPoint(x: locationsMinimisedGuide.frame.minX, y: locationsMinimisedGuide.frame.minY), size: locationsExpandeGuide.frame.size)
        
        locationsTable.frame.size = self.locationsExpandeGuide.frame.size
        locationsTable.frame = CGRect(origin: CGPoint(x: locationsMinimisedGuide.frame.minX, y: locationsMinimisedGuide.frame.minY + 60), size: locationsExpandeGuide.frame.size)
        
        locationTableBackground.layer.cornerRadius = 12
        locationTableBackground.layer.masksToBounds = true
        
        
        favouritesButton.frame.size = CGSize(width: locationTableBackground.frame.width, height: 60)
        favouritesButton.center = CGPoint(x: self.locationTableBackground.frame.width/2, y: self.favouritesButton.frame.height/2)
        
        favouritesIcon.frame.size = CGSize(width: 30, height: 30)
        favouritesIcon.center = CGPoint(x: 30 + favouritesIcon.frame.width/2, y: self.favouritesButton.center.y)
        
        favouritesLabel.frame.size = CGSize(width: self.locationTableBackground.frame.width - (favouritesIcon.frame.maxX + 20), height: favouritesIcon.frame.height)
        favouritesLabel.center = CGPoint(x: (favouritesIcon.frame.maxX + 20) + favouritesLabel.frame.width/2, y: self.favouritesButton.center.y)
        favouritesLabel.text = "Favourites"
        favouritesLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFontWeightMedium)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == locationsTable {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0xE4E3E9)
        return view
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationManager.stopUpdatingLocation()
        
        let location = locations.last
        mapView.showsUserLocation = true
        
        
        let center = CLLocationCoordinate2D(latitude: ((location?.coordinate.latitude)!), longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        print("Located")
        
        mapView.setRegion(region, animated: true)
        
        
        if manager.location != nil {
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
                if (error != nil) {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count != 0 {
                    
                    let placemark = placemarks![0] as CLPlacemark
                    self.curateSearchTerms(region: region, placemark: placemark)
                    
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func curateSearchTerms(region: MKCoordinateRegion, placemark: CLPlacemark) {
        
        var selectedLanguage = [String]()
        
        if let country = placemark.country {
            for (language, countries) in langCountries {
                
                if countries.contains(country) {
                    selectedLanguage.append(contentsOf: transArray[language]!)
                }
                
            }
        }
        
        for searchTerm in transArray["English"]! {
            selectedLanguage.append(searchTerm)
        }
        
        let unique = Array(Set(selectedLanguage))
        
        self.performSearch(region: region, placemark: placemark, searchTerms: unique, radius: 1000)
        
    }
    
    func performSearch(region: MKCoordinateRegion, placemark: CLPlacemark, searchTerms: [String], radius: Double)  {
        
        
        for (index, searchTerm) in searchTerms.enumerated() {
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchTerm
            request.region = region
            request.region = MKCoordinateRegionMakeWithDistance(region.center, radius, radius)
            
            
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    print("There was an error searching for: \(String(describing: request.naturalLanguageQuery)) error: \(String(describing: error))")
                    return
                }
                
                print("A Search has been done")
                
                for item in response.mapItems {
                    
                    //TODO - FIX MAP REGION TO CENTRE
                    //TODO - ADD ANNOTATION TITLES TO ANNOTATIONS
                    
                    if !self.mapItemsFound.contains(item) {
                        let point = MKPointAnnotation()
                        point.coordinate = item.placemark.coordinate
                        point.title = item.name
                        
                        
                        self.mapItemsFound.append(item)
                        
                        //item.
                        
                        let currentLocation = CLLocation(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                        
                        let endLocation = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                        
                        var distance:Double = Double(endLocation.distance(from: currentLocation)/1000)
                        
                        
                        distance = round(distance * 10) / 10
                        
                        _ = "\(distance)" + " KM"
                        
                        let newClinic = self.createClinic(receivedClinic: item)
                        
                        point.subtitle = newClinic.location
                        self.mapView.addAnnotation(point)
                        
                        self.annotations.append(point)
                        
                        
                        newClinic.distance = ""
                        newClinic.duration = ""
                        
                        self.clinicsFound.append(newClinic)
                        
                        self.locationsTable.reloadData()
                    }
                    
                    //self.getTravelTime(placemark, to: item.placemark, index: self.clinicsFound.count-1)
                    
                }
                
                if index == searchTerms.count - 1 {
                    
                    if self.mapItemsFound.count >= 3 {
                        
                        print(self.mapItemsFound.count)
                        self.activityIndicator.stopAnimating()
                        
                        
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                            
                            self.locationTableBackground.frame = CGRect(origin: CGPoint(x: self.locationsNormalGuide.frame.minX, y: self.locationsNormalGuide.frame.minY), size: self.locationTableBackground.frame.size)
                            self.locationsTable.frame = CGRect(origin: CGPoint(x: self.locationsNormalGuide.frame.minX, y: self.locationsNormalGuide.frame.minY + 60), size: self.locationsTable.frame.size)
                            
                            
                        }, completion: { (finished) in
                            self.locationTableBackground.addGestureRecognizer(self.swipeGesture)
                        })
                        
                        
                        
                    } else {
                        self.performSearch(region: region, placemark: placemark, searchTerms: searchTerms, radius: radius + 2000)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func createClinic (receivedClinic: MKMapItem) -> Clinic {
        
        let newClinic = Clinic()
        
        if let name = receivedClinic.name {
            newClinic.name = name
        } else {
            newClinic.name = ""
        }
        
        var streetNumber = "" //subthot
        var streetName = "" //thoroughfare
        var suburb = "" //locality
        var state = "" // adminarea
        
        newClinic.suburb = suburb
        if let number = receivedClinic.placemark.subThoroughfare {
            streetNumber = number + " "
        }
        if let name = receivedClinic.placemark.thoroughfare {
            streetName = name + ", "
        }
        if let addressSuburb = receivedClinic.placemark.locality {
            
            newClinic.suburb = addressSuburb
            
            suburb = addressSuburb + ", "
        }
        if let addressState = receivedClinic.placemark.administrativeArea {
            state = addressState
        }
        
        
        
        let addressString = streetNumber + streetName + suburb + state
        
        newClinic.location = addressString
        
        if let phoneNumber = receivedClinic.phoneNumber {
            newClinic.phone = phoneNumber
        } else {
            newClinic.phone = ""
        }
        
        if let url = receivedClinic.url {
            newClinic.url = url.absoluteString
        } else {
            newClinic.url = ""
        }
        
        newClinic.formattedLocation = formatLocation(placemark: receivedClinic.placemark)
        
        print(Double(receivedClinic.placemark.coordinate.latitude))
        print(Double(receivedClinic.placemark.coordinate.longitude))
        
        newClinic.latitude = "\(receivedClinic.placemark.coordinate.latitude)"
        newClinic.longitude = "\(receivedClinic.placemark.coordinate.longitude)"
        
        return newClinic
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == locationsTable {
            
            return 75
            
        } else {
            return 50
        }
        
    }
    
    func formatLocation(placemark:CLPlacemark) -> String {
        
        
        var streetNumber = "" //subthot
        var streetName = "" //thoroughfare
        var suburb = "" //locality
        var state = "" // adminarea
        var postCode = ""
        var country = ""
        
        var line1 = ""
        var line2 = ""
        var line3 = ""
        
        if let number = placemark.subThoroughfare {
            streetNumber = number + " "
        }
        if let name = placemark.thoroughfare {
            streetName = name
        }
        
        line1 = streetNumber + streetName
        
        if let addressSuburb = placemark.locality {
            suburb = addressSuburb + " "
        }
        
        if let addressState = placemark.administrativeArea {
            state = addressState + " "
        }
        
        if let postalCode = placemark.postalCode {
            postCode = postalCode
        }
        
        line2 = suburb + state + postCode
        
        if let countryUnwrapped = placemark.country {
            country = countryUnwrapped
        }
        
        line3 = country
        
        return line1 + ", " + line2 + ", " + line3
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == locationsTable {
            
            return mapItemsFound.count
            
            
        } else {
            return categories.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == locationsTable {
            
            
            let cell: clinicTableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! clinicTableCell
            
            cell.clinicName.text = clinicsFound[indexPath.row].name
            //cell.distanceLabel.text = clinicsFound[indexPath.row].distance
            
            //cell.clinicName.font = UIFont(name: (cell.clinicName.font?.fontName)!, size: (18.0 * globalRatio) + 0.5)
            cell.separatorInset = UIEdgeInsets.zero
            
            if let suburb = mapItemsFound[indexPath.row].placemark.locality {
                cell.locationLabel.text = suburb
            }
            
            //    print(globalRatio)
            print(cell.clinicName.font.pointSize)
            
            /*    let distanceComponents = clinicsFound[indexPath.row].distance.componentsSeparatedByString(" ")
             
             if distanceComponents.count == 2 {
             
             cell.durationLabel.text = distanceComponents[0]
             cell.durationUnits.text = distanceComponents[1]
             
             } else {
             cell.durationLabel.hidden = true
             cell.durationUnits.hidden = true
             }
             
             cell.durationLabel.font = UIFont(name: (cell.durationLabel.font?.fontName)!, size: (27.0 * globalRatio) + 0.5)
             
             cell.colourIndicator.backgroundColor = hexColor(leftColours[indexPath.row % 3])*/
            return cell
            
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCat") as! CategoryTableViewCell
            
            for subview in cell.subviews {
                if let _:UILabel = subview as? UILabel {
                    subview.removeFromSuperview()
                    
                }
            }
            let catLabel = UILabel(frame: self.categoryLabel.frame)
            catLabel.text = categories[indexPath.row]
            catLabel.font = categoryLabel.font
            cell.addSubview(catLabel)
            catLabel.center.y = cell.contentView.center.y
            cell.backgroundColor = .clear
            
            if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
                cell.separatorInset = UIEdgeInsets.zero
            }
            
            if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
                cell.preservesSuperviewLayoutMargins = false
            }
            
            if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
                cell.layoutMargins = UIEdgeInsets.zero
            }
            
            
            return cell
            
        }
    }
    
    
    
    @IBAction func changeCategory(_ sender: Any) {
        
        selectingCategory = !selectingCategory
        
        if selectingCategory {
            
            if self.locationTableBackground.frame.minY == self.locationsExpandeGuide.frame.minY {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.locationTableBackground.frame.origin.y = self.locationsNormalGuide.frame.minY
                    self.locationsTable.frame.origin.y = self.locationsNormalGuide.frame.minY + 60
                    
                }, completion: { (finished) in
                    
                })
            }
            
            self.categoriesTable.frame = self.changeSearchView.frame
            self.listBackground.frame = self.changeSearchView.frame
            self.listShadow.frame = self.buttonShadow.frame
            
            //self.categoriesTable.frame.size = CGSize(width: self.changeSearchView.frame.width, height: self.changeSearchView.frame.height/2)
            self.categoriesTable.frame.size = CGSize(width: self.changeSearchView.frame.width, height: self.changeSearchView.frame.height/2)
            self.categoriesTable.center.y = self.changeSearchView.center.y
            self.categoriesTable.alpha = 1
            
            self.listBackground.frame.size = CGSize(width: self.changeSearchView.frame.width, height: self.changeSearchView.frame.height/2)
            self.listBackground.center.y = self.changeSearchView.center.y
            self.listBackground.alpha = 1
            
            self.listShadow.frame.size = CGSize(width: self.buttonShadow.frame.width, height: self.changeSearchView.frame.height/2)
            self.listShadow.center.y = self.buttonShadow.center.y
            
            
            UIView.animate(withDuration: 0.33, animations: {
                
                
                self.categoriesTable.frame = CGRect(x: self.categoriesTable.frame.minX, y: self.changeSearchView.frame.maxY + 3, width: self.changeSearchView.frame.width, height: 164)
                self.listBackground.frame = CGRect(x: self.listBackground.frame.minX, y: self.changeSearchView.frame.maxY + 3, width: self.changeSearchView.frame.width, height: 164)
                self.listShadow.frame = CGRect(x: self.listShadow.frame.minX, y: self.changeSearchView.frame.maxY + (self.changeSearchView.frame.height - self.buttonShadow.frame.height)/2 + 3 , width: self.buttonShadow.frame.width, height: 164 - (self.changeSearchView.frame.height - self.buttonShadow.frame.height))
                self.listShadow.alpha = 1
            })
            
        } else {
            
            if self.locationTableBackground.frame.minY == self.locationsExpandeGuide.frame.minY {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.locationTableBackground.frame.origin.y = self.locationsNormalGuide.frame.minY
                    self.locationsTable.frame.origin.y = self.locationsNormalGuide.frame.minY + 60
                    
                }, completion: { (finished) in
                    
                })
            }
            
            UIView.animate(withDuration: 0.33, animations: {
                
                self.categoriesTable.frame = self.changeSearchView.frame
                self.categoriesTable.center.y = self.changeSearchView.center.y
                
                self.listBackground.frame = self.changeSearchView.frame
                self.listBackground.center.y = self.changeSearchView.center.y
                
                self.listShadow.frame = self.buttonShadow.frame
                self.listShadow.center.y = self.buttonShadow.center.y
                self.listShadow.alpha = 0
                
            }, completion: { (finished) in
                
                self.categoriesTable.alpha = 0
                self.listBackground.alpha = 0
                
                
            })
            
        }
        
    }
    
    
    func goToFavourites() {
        self.performSegue(withIdentifier: "showFavourites", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            self.share(index: indexPath.row)
        }
        share.backgroundColor = UIColor.blue
        //share.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellShare")!)
        
        let favorite = UITableViewRowAction(style: .normal, title: "         ") { action, index in
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
        favorite.backgroundColor = UIColor.orange
        
        //favorite.backgroundColor = UIColor(patternImage: UIImage(named: "ColouredCellFavourites")!)
        
        if favouriteClinics.contains(clinicsFound[indexPath.row]) {
            return [share]
        }
        
        if isFavourite(clinic: clinicsFound[indexPath.row]) {
            return [share]
        }
        
        return [favorite, share]
        
    }
    
    func favourite (index: Int) {
        
        let favesData = UserDefaults.standard.object(forKey: "favourites") as? NSData
        if let favouritesData = favesData {
            favouriteClinics = (NSKeyedUnarchiver.unarchiveObject(with: favouritesData as Data) as? [Clinic])!
        } else {
            
            let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouriteClinics)
            UserDefaults.standard.set(favouritesData, forKey: "favourites")
        }
        
        let faveClinic = clinicsFound[index]
        favouriteClinics.append(faveClinic)
        
        let favouritesData = NSKeyedArchiver.archivedData(withRootObject: self.favouriteClinics)
        UserDefaults.standard.set(favouritesData, forKey: "favourites")
        
        self.locationsTable.reloadData()
        
    }
    
    
    func share (index: Int) {
        
        let shareName = clinicsFound[index].name
        let shareLocation = clinicsFound[index].location
        let sharePhone = clinicsFound[index].phone
        
        let shareText = "I just located this medical clinic on Medyc: \n\(shareName) at \(shareLocation)\n\(sharePhone)"
        
        let shareItems:Array = [shareText]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func isFavourite(clinic: Clinic) -> Bool {
        for favourite in favouriteClinics {
            if clinic.name == favourite.name && clinic.location == favourite.location {
                return true
            }
        }
        return false
    }
    
    
}
