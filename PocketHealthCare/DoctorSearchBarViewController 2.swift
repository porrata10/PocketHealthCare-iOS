//
//  DoctorSearchBarViewController.swift
//  PocketHealthCare
//
//  Created by Luis Valledor on 1/11/20.
//  Copyright © 2020 Ricardo Porrata. All rights reserved.
//

import UIKit

class DoctorSearchBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

   
    @IBOutlet weak var doctorSearchBar: UISearchBar!
    @IBOutlet weak var doctorsTableView: UITableView!
    
    var doctorArray:[DoctorModel] = [DoctorModel]()
    var filteredDoctorArray:[DoctorModel] = [DoctorModel]()
    var isSearching = false
    let medicalPlanService = MedicalPlanService()
    let doctorService = DoctorService()
   
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(hex: 0xEDEFF1)
        
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        doctorSearchBar.delegate = self
        
        let nibName = UINib(nibName: "DoctorTableViewCell", bundle: nil)
        doctorsTableView.register(nibName, forCellReuseIdentifier:"doctorViewCell")
        
        SetDoctorCell()
        configureTableView()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDoctorArray.count
        }else {
            return doctorArray.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorsTableView.dequeueReusableCell(withIdentifier: "doctorViewCell") as! DoctorTableViewCell
        
        if isSearching{
            cell.doctorNameLabel.text = filteredDoctorArray[indexPath.row].Name
            cell.specialtyNameLabel.text = filteredDoctorArray[indexPath.row].Specialty
            cell.townNameLabel.text = filteredDoctorArray[indexPath.row].City
        } else{
            cell.doctorNameLabel.text = doctorArray[indexPath.row].Name
            cell.specialtyNameLabel.text = doctorArray[indexPath.row].Specialty
            cell.townNameLabel.text = doctorArray[indexPath.row].City
        }
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if doctorSearchBar.text == "" {
            isSearching = false
            doctorsTableView.reloadData()
        } else {
            isSearching = true
            filteredDoctorArray = doctorArray.filter({$0.Name.contains(searchBar.text ?? "")})
            doctorsTableView.reloadData()
        }
    }
    
    
    
    func SetDoctorCell(){
        doctorService.getDoctors { (results) in
            guard let doctors = results else {return}
            
            doctors.forEach { (doctor) in
                self.doctorArray.append(doctor)
                self.doctorsTableView.reloadData()
            }
        }
    }
    
    
    
    func configureTableView()
       {
            doctorsTableView.rowHeight = UITableView.automaticDimension;
            doctorsTableView.estimatedRowHeight = 120.0;
            doctorsTableView.separatorStyle = .none;
            //doctorsTableView.backgroundColor = UIColor.white
       }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchBarToDoctorInformation", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DoctorInformationViewController{
            
            if isSearching {
                    destination.doctorID = filteredDoctorArray[(doctorsTableView.indexPathForSelectedRow?.row)!].DoctorID
                    doctorsTableView.deselectRow(at: doctorsTableView.indexPathForSelectedRow!, animated: true)
            }
            
            else {
                destination.doctorID = doctorArray[(doctorsTableView.indexPathForSelectedRow?.row)!].DoctorID
                doctorsTableView.deselectRow(at: doctorsTableView.indexPathForSelectedRow!, animated: true)
            }
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110

    }

}

