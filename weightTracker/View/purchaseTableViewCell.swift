//
//  purchaseTableViewCell.swift
//  weightTracker
//
//  Created by Deepak on 15/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class purchaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImage.layer.cornerRadius = 25.0
        cellImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
