//
//  TableViewCell.swift
//  TestContacts
//
//  Created by Dave on 8/11/20.
//  Copyright © 2020 DaKar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel! 
    @IBOutlet weak var lastname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
