//
//  cell.swift
//  Citizen
//
//  Created by Mickaël Jordan on 18/02/15.
//  Copyright (c) 2015 Mickaël Jordan. All rights reserved.
//

import UIKit

class cell: UITableViewCell {


    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postMetric: UILabel!
    
    @IBOutlet weak var postEvolution: UILabel!
    
    @IBOutlet weak var postChart: UIImageView!
    
    @IBOutlet weak var postSource: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

}