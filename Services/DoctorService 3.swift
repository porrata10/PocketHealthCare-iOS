//
//  DoctorService.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class DoctorService
{
    
    let apiURL = "http://64.225.2.139/doctor/"
    
    
    func getDoctors(completionHandler: @escaping ([DoctorModel]?) -> Void)
    {
        
        let newURL = apiURL + "getDoctors";
        
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
                        let doctors = try JSONDecoder().decode([DoctorModel].self, from: data)
                        completionHandler(doctors)
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
    
    
    
    
    func getDoctorInformationByID(id: Int, completionHandler: @escaping (DoctorInformationModel?) -> Void)
    {
        
        let newURL = apiURL + "getDoctorInformation/\(id)"
        
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
                        let doctorInformation = try JSONDecoder().decode(DoctorInformationModel.self, from: data)
                        completionHandler(doctorInformation)
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
    
    
    
    func searchForDoctor(specialty: String, city : String, plan : String, completionHandler: @escaping ([DoctorModel]?) -> Void)
    {
        
        let newURL = apiURL + "doctorSearch?specialty=\(specialty)&city=\(city)&plan=\(plan)"
                
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
                        let doctors = try JSONDecoder().decode([DoctorModel].self, from: data)
                        completionHandler(doctors)
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
    
    
    func getDoctorCityOptions(completionHandler: @escaping ([CityModel]?) -> Void)
    {
        
        let newURL = apiURL + "getDoctorsCityOptions";
        
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
                        let cities = try JSONDecoder().decode([CityModel].self, from: data)
                        completionHandler(cities)
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
    
    
    
    func getDoctorSpecialtyOptions(completionHandler: @escaping ([SpecialtyModel]?) -> Void)
    {
        
        let newURL = apiURL + "getDoctorsSpecialtyOptions";
        
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
                        let specialties = try JSONDecoder().decode([SpecialtyModel].self, from: data)
                        completionHandler(specialties)
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



