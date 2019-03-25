//
//  FormTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 5/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak var formEntryTextfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
