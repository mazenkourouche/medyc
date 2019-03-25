//
//  SelectedInfoTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 26/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class SelectedInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
