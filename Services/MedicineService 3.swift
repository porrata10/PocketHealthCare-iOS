//
//  MedicineService.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MedicineService
{
    
    let apiURL = "http://64.225.2.139/medicine/"
    
    
    func getMedicines(completionHandler: @escaping ([MedicineModel]?) -> Void)
    {
        
        let newURL = apiURL + "getMedicines";
        
        Alamofire.request(newURL, method: .get).responseJSON{ (response) in
            switch response.result{
            case .success:
                
                if(response.error != nil)
                {
                    print(response.error!)
                }
                else
                {
                    guard let data = response.data else {
                        
                        completionHandler(nil)
                        return
                    }
                    
                    do{
                        let medicines = try JSONDecoder().decode([MedicineModel].self, from: data)
                        completionHandler(medicines)
                        return
                        
                    }catch let jsonError {
                        print("An error occurred while decoding the JSON data. Details: \(jsonError)")
                    }
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
    }
    
    
    
    func getMedicineInformationByID(id: Int, completionHandler: @escaping (MedicineInformationModel?) -> Void)
    {
        
        let newURL = apiURL + "getMedicineInformation/\(id)"
        
        Alamofire.request(newURL, method: .get).responseJSON{ (response) in
            switch response.result{
            case .success:
                
                if(response.error != nil)
                {
                    print(response.error!)
                }
                else
                {
                    guard let data = response.data else {
                        
                        completionHandler(nil)
                        return
                    }
                    
                    do{
                        let medicineInformation = try JSONDecoder().decode(MedicineInformationModel.self, from: data)
                        completionHandler(medicineInformation)
                        return
                        
                    }catch let jsonError {
                        print("An error occurred while decoding the JSON data. Details: \(jsonError)")
                    }
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
    }
    
    
    func searchForMedicine(medicalPlan: String, dosage : Int, sorting : String, completionHandler: @escaping ([MedicineModel]?) -> Void)
    {
        
        let newURL = apiURL + "medicineSearch?plan=\(medicalPlan)&dose=\(dosage)&sort\(sorting)"
        
        Alamofire.request(newURL, method: .get).responseJSON{ (response) in    switch response.result{
        case .success:
            
            if(response.error != nil)
            {
                print(response.error!)
            }
            else
            {
                guard let data = response.data else {
                    
                    completionHandler(nil)
                    return
                }
                
                do{
                    let medicines = try JSONDecoder().decode([MedicineModel].self, from: data)
                    completionHandler(medicines)
                    return
                    
                }catch let jsonError {
                    print("An error occurred while decoding the JSON data. Details: \(jsonError)")
                }
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            break
            }
        }
        
    }
    
}

