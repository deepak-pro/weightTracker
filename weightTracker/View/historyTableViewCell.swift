//
//  historyTableViewCell.swift
//  weightTracker
//
//  Created by Deepak on 24/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class historyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
