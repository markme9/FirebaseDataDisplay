//
//  MyTableViewCell.swift
//  FirebaseDataDisplay
//
//  Created by mark me on 6/17/20.
//  Copyright © 2020 mark me. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastNaneLabel: UILabel!
    @IBOutlet var emailIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
        
    }
    
    
    
}
