//
//  DoctorViewController.swift
//  PocketHealthCare
//
//  Created by Ricardo Porrata on 12/26/19.
//  Copyright © 2019 Ricardo Porrata. All rights reserved.
//

import UIKit
import iOSDropDown

class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
  
    @IBOutlet weak var doctorsTableView: UITableView!
    @IBOutlet weak var MedicalPlanTextField: UITextField!
    @IBOutlet weak var SpecialtyTextField: UITextField!
    @IBOutlet weak var TownTextField: UITextField!
    
    var doctorArray:[DoctorModel] = [DoctorModel]()
    let medicalPlanService = MedicalPlanService()
    let doctorService = DoctorService()
    var medicalPlanOptions : [String] = []
    var specialtyOptions : [String] = []
    var townsOptions : [String] = []
    var activeArray : [String] = []
    var selectedTextField : Int = 0
    var medicalPlanOption : String = ""
    var specialtyOption : String = ""
    var townOption : String = ""
    
    var pickerView = UIPickerView()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xEDEFF1)
        
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        let nibName = UINib(nibName: "DoctorTableViewCell", bundle: nil)
        doctorsTableView.register(nibName, forCellReuseIdentifier:"doctorViewCell")
            
        SetDropDowns()
        SetDoctorCell()
        configureTableView()
        setUpTextFields()
        
    }
    
    @IBAction func medicalPlanDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    @IBAction func specialtyDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    @IBAction func townsDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorsTableView.dequeueReusableCell(withIdentifier: "doctorViewCell") as! DoctorTableViewCell
        
        
        cell.doctorNameLabel.text = doctorArray[indexPath.row].Name
        cell.specialtyNameLabel.text = doctorArray[indexPath.row].Specialty
        cell.townNameLabel.text = doctorArray[indexPath.row].City
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DoctorInformationIdentifier", sender: self)
    }
    
    func SetDropDowns(){
        medicalPlanService.getMedicalPlanOptions { (results) in
            guard let medicalPlans = results else {return}
            
            medicalPlans.forEach { (medicalPlan) in
                self.medicalPlanOptions.append(medicalPlan.Name)
            }
            
        }
        
        doctorService.getDoctorSpecialtyOptions { (results) in
            guard let specialties = results else {return}
            
            specialties.forEach { (specialty) in
                self.specialtyOptions.append(specialty.Name)
            }
            
        }
        
        doctorService.getDoctorCityOptions { (results) in
            guard let towns = results else {return}
            
            towns.forEach { (town) in
                self.townsOptions.append(town.Name)
            }
            
        }

    }
    
    
    func setUpTextFields() {
        
        MedicalPlanTextField.delegate = self
        SpecialtyTextField.delegate = self
        TownTextField.delegate = self
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return activeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return activeArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextField == 1 {
            
            MedicalPlanTextField.text = activeArray[row]
            medicalPlanOption = activeArray[row]
            pickerView.isHidden = true
        }
        
        else if selectedTextField == 2 {
            
            SpecialtyTextField.text = activeArray[row]
            specialtyOption = activeArray[row]
            pickerView.isHidden = true
        }
        
        else if selectedTextField == 3 {
            
            TownTextField.text = activeArray[row]
            townOption = activeArray[row]
            pickerView.isHidden = true
        }
        
        
        
        doctorService.searchForDoctor(specialty: specialtyOption, city: townOption, plan: medicalPlanOption) { (result) in
            guard let doctors = result else {return}
            

            self.doctorArray = []
            doctors.forEach { (doctor) in
                self.doctorArray.append(doctor)
            }
                
            self.doctorsTableView.reloadData()
        }
                
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == MedicalPlanTextField {
            
            pickerView.isHidden = false
        }
        
        else if textField == SpecialtyTextField {
            
            pickerView.isHidden = false
        }
        
        
        else if textField == TownTextField {
            
            pickerView.isHidden = false
        }
    }
    
    
    func createPickerView(_ dropDown : Int) {
        
        if dropDown == 1 {
            pickerView.delegate = self
            activeArray = medicalPlanOptions
            selectedTextField = 1
            MedicalPlanTextField.inputView = pickerView
        }
        
        else if dropDown == 2 {
            pickerView.delegate = self
            activeArray = specialtyOptions
            selectedTextField = 2
            SpecialtyTextField.inputView = pickerView
        }
        
        
        else if dropDown == 3 {
            
            pickerView.delegate =  self
            activeArray = townsOptions
            selectedTextField = 3
            TownTextField.inputView = pickerView
        }
    }
    
    func dismissPickerView(_ selectedPicker : Int) {
        
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
                
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        
        if selectedPicker == 1 {
            
            MedicalPlanTextField.inputView = toolbar
        }
        
       else if selectedPicker == 2 {
                  
            SpecialtyTextField.inputView = toolbar
        }
        
        else if selectedPicker == 3 {
                  
            TownTextField.inputView = toolbar
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DoctorInformationViewController{
            destination.doctorID = doctorArray[(doctorsTableView.indexPathForSelectedRow?.row)!].DoctorID
            doctorsTableView.deselectRow(at: doctorsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110

    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
}


extension UIColor {
    
    convenience init(hex : Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}
