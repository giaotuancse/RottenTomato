//
//  MovieItemCell.swift
//  RottenTomato
//
//  Created by Giao Tuan on 11/11/15.
//  Copyright © 2015 LiFish. All rights reserved.
//

import UIKit

class MovieItemCell: UITableViewCell {

    @IBOutlet weak var sysnosypLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var yearsLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
