//
//  File.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
struct DoctorInformationModel : Decodable
{
    let DoctorsInformation : DoctorModel
    let MedicalPlans : [MedicalPlanModel]
}
