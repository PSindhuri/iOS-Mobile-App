//
//  SummaryPrototypeTableViewCell.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/8/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

// View Cell for Expenditure log table in Summary View Controller
class SummaryPrototypeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    func loadCellValues(title: String, day: String,amount:String)
    {
        amountLabel.text=amount
        titleLabel.text=title
        dayLabel.text=day
    }
}
