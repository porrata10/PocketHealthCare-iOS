//
//  MedicalPlanService.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
import Alamofire

class MedicalPlanService
{
    
    let apiURL = "http://64.225.2.139/medicalPlan/"
    
    func getMedicalPlanOptions(completionHandler: @escaping ([MedicalPlanModel]?) -> Void)
    {
        
        let newURL = apiURL + "getMedicalPlanOptions";
        
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
                        let medicalPlans = try JSONDecoder().decode([MedicalPlanModel].self, from: data)
                        completionHandler(medicalPlans)
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
