//
//  DoctorTableViewCell.swift
//  PocketHealthCare
//
//  Created by Luis Valledor on 1/5/20.
//  Copyright © 2020 Ricardo Porrata. All rights reserved.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var specialtyNameLabel: UILabel!
    @IBOutlet weak var townNameLabel: UILabel!
    @IBOutlet weak var DoctorCellView: UIView!
    
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DoctorCellView.layer.cornerRadius = 10;
        DoctorCellView.layer.masksToBounds = true;
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
