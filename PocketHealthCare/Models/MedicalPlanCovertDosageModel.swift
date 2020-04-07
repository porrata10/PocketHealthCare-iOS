//
//  MedicalPlanCovertDosageModel.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
struct MedicalPlanCovertDosageModel : Decodable
{
    let MedicalPlanCovert_ID: Int
    let MedicalPlan: String
    let Covert: String
    let DosageAmount: Double
}
