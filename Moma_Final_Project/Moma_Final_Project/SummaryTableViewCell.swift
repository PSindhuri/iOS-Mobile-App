//
//  SummaryTableViewCell.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/7/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    func loadCellValues(title: String, day: String,amount:String) {
       amountLabel.text=amount
       titleLabel.text=title
        dayLabel.text=day
    }
}//end
