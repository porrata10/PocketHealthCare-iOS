//
//  MedicineModel.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation

struct MedicineModel : Decodable
{
    let MedicineID : Int
    let Name : String
    let Purpose : String
    let Description : String
    let Category : String
}
