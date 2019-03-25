//
//  FavouriteButtonTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 28/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class FavouriteButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
