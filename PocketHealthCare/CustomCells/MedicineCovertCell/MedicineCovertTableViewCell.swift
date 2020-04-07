//
//  MedicineCovertTableViewCell.swift
//  PocketHealthCare
//
//  Created by Luis Valledor on 2/5/20.
//  Copyright © 2020 Ricardo Porrata. All rights reserved.
//

import UIKit

class MedicineCovertTableViewCell: UITableViewCell {

    
    @IBOutlet weak var covert: UILabel!
    @IBOutlet weak var medicalPlan: UILabel!
    
    @IBOutlet weak var dosage: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
