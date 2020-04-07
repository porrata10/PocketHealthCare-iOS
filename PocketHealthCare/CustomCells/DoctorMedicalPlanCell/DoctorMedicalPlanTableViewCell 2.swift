//
//  DoctorMedicalPlanTableViewCell.swift
//  PocketHealthCare
//
//  Created by Luis Valledor on 1/18/20.
//  Copyright © 2020 Ricardo Porrata. All rights reserved.
//

import UIKit

class DoctorMedicalPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var MedicalPlanCell: UIView!
    @IBOutlet weak var medicalPlanLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MedicalPlanCell.layer.cornerRadius = 10;
        MedicalPlanCell.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
