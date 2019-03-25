//
//  ClinicMapTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import MapKit
class ClinicMapTableViewCell: UITableViewCell {

    @IBOutlet weak var clinicMap: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
