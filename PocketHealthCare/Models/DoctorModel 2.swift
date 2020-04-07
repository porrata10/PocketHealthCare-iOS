//
//  DoctorModel.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
struct DoctorModel : Codable
{
    var DoctorID : Int
    var Name : String
    var Specialty: String
    var Latitude: Double
    var Longitude: Double
    var Address1 : String
    var Address2 : String
    var City: String
    var State: String
    var Country: String
    var ZipCode : Int
}
