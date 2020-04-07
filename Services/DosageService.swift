//
//  DosageService.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
import Foundation
import Alamofire

class DosageService
{
    
    let configuration = Configuration()
    
    func getDosageOptions(completionHandler: @escaping ([DosageModel]?) -> Void)
    {
        
        let newURL = configuration.dosageApiUrl + "getDosagesOptions";
        
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
                        let dosages = try JSONDecoder().decode([DosageModel].self, from: data)
                        completionHandler(dosages)
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
