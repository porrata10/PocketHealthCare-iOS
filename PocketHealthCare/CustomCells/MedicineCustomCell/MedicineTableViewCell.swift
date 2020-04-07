//
//  MedicineTableViewCell.swift
//  PocketHealthCare
//
//  Created by Luis Valledor on 2/5/20.
//  Copyright © 2020 Ricardo Porrata. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    
    @IBOutlet weak var MedicineCategoryLabel: UILabel!
    @IBOutlet weak var MedicineNameLabel: UILabel!
    @IBOutlet weak var MedicineCellView: UIView!
    
    @IBOutlet weak var MedicinePurposeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MedicineCellView.layer.cornerRadius = 10;
        
//        MedicineCellView.conrnerRadius(usingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 15, height: 15))

    
        MedicineCellView.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
