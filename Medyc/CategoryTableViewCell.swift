//
//  CategoryTableViewCell.swift
//  Medyc
//
//  Created by Mazen Kourouche on 25/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    var catLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.addSubview(catLabel)
        self.catLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.catLabel.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        catLabel.frame = self.contentView.frame
        catLabel.backgroundColor = .red
        
    }

}
