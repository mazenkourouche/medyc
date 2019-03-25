//
//  TextfieldTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 24/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class TextfieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    
    @IBOutlet weak var sideIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
