//
//  MedicineInformationModel.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
struct MedicineInformationModel : Decodable
{
    
    let MedicineInformation : MedicineModel
    let AdministrationType : [AdministrationTypeModel]
    let MedicalPlanDosage : [MedicalPlanCovertDosageModel]
}
