







import UIKit

class MedicineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var MedicalPlansTextField: UITextField!
    @IBOutlet weak var DosageTextField: UITextField!
    @IBOutlet weak var OrderByTextField: UITextField!
    @IBOutlet weak var MedicinesTableView: UITableView!
    
    
    enum FilterDropDownOptions : Int {
        
        case MedicalPlan = 1
        case Dosage =  2
        case OrderBy = 3
    }
    
    enum DefaultDropDownOptions : String {
        
        case MedicalPlan = "Medical Plan"
        case Dosage = "Dosage"
        case OrderBy = "Name"
    }
    
    let medicalPlanService = MedicalPlanService()
    let dosageService = DosageService()
    let medicineService = MedicineService()
    var medicinesArray: [MedicineModel] = [MedicineModel]()
    var medicalPlansOptions : [String] = ["Medical Plan"]
    var dosagesOptions : [String] = ["Dosage"]
    var orderByOptions : [String] = ["Name", "Category", "Purpose"]
    var activeArray : [String] = []
    var selectedTextField : Int = 0
    var medicalPlanOption : String = ""
    var dosageOption : String = ""
    var orderOption : String = ""
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureTextFields()
        configureTableView()
        getDropDownOptions()
        getMedicineCellsInformation()
    }
    
    // MARK: IBActions
    
    
    @IBAction func medicalPlanDropDownSelected(_ sender: UITextField) {
        
        self.createPickerViewForTextFields(sender.tag)
    }
    
    
    @IBAction func dosageDropDownSelected(_ sender: UITextField) {
        
        self.createPickerViewForTextFields(sender.tag)
    }
    
    
    @IBAction func orderByDropDownSelected(_ sender: UITextField) {
        
        self.createPickerViewForTextFields(sender.tag)
    }
    
    
    // MARK: TableView methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return medicinesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MedicinesTableView.dequeueReusableCell(withIdentifier: "customMedicineCell", for: indexPath) as! MedicineTableViewCell
        
        cell.MedicineNameLabel.text = medicinesArray[indexPath.row].Name
        cell.MedicinePurposeLabel.text = medicinesArray[indexPath.row].Purpose
        cell.MedicineCategoryLabel.text = medicinesArray[indexPath.row].Category
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "FromMedicineToInformation", sender: self)
    }
    
    
    func getMedicineCellsInformation(){
        
        medicineService.getMedicines { (result) in
            guard let medicines = result else {return}
            
            medicines.forEach({ (medicine) in
                self.medicinesArray.append(medicine)
                self.MedicinesTableView.reloadData()
            })
        }
    }
    
    
    // MARK: PickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return activeArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return activeArray.count
    }
    
    
    /**
     When a textfield is selected it displays the selected option
     
     # Important Notes#
     1. The value that is selected is then used as a parameter to be send to the API to retrieve data from the database.
     */
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextField == FilterDropDownOptions.MedicalPlan.rawValue {
            
            
            if activeArray[row] == DefaultDropDownOptions.MedicalPlan.rawValue {
                
                MedicalPlansTextField.text = DefaultDropDownOptions.MedicalPlan.rawValue
                medicalPlanOption = ""
            }
                
            else {
                
                MedicalPlansTextField.text = activeArray[row]
                medicalPlanOption = activeArray[row]
            }
            
            self.pickerView.isHidden = true
            MedicalPlansTextField.resignFirstResponder()
        }
            
        else if selectedTextField == FilterDropDownOptions.Dosage.rawValue {
            
            if activeArray[row] == DefaultDropDownOptions.Dosage.rawValue {
                
                DosageTextField.text = DefaultDropDownOptions.Dosage.rawValue
                dosageOption = ""
            }
            else {
                
                DosageTextField.text = activeArray[row]
                dosageOption = activeArray[row]
            }
            
            self.pickerView.isHidden = true
            DosageTextField.resignFirstResponder()
        }
            
        else if selectedTextField == FilterDropDownOptions.OrderBy.rawValue {
            
            OrderByTextField.text = activeArray[row]
            
            if activeArray[row] == "Name" {
                
                orderOption = "med"
            }
                
            else if activeArray[row] == "Category" {
                
                orderOption = "cat"
            }
                
            else if activeArray[row] == "Purpose"{
                
                
                orderOption = "pur"
            }
            
            
            self.pickerView.isHidden = true
            OrderByTextField.resignFirstResponder()
        }
        
        // Getting the data fmor the database with the selected values from the pickerview
        medicineService.searchForMedicine(medicalPlan: medicalPlanOption, dosage: dosageOption, sorting: orderOption) { (result) in
            guard let medicines = result else {return}
            
            
            self.medicinesArray = []
            medicines.forEach({ (medicine) in
                self.medicinesArray.append(medicine)
                
            })
            self.MedicinesTableView.reloadData()
        }
        
        
        self.pickerView.endEditing(true)
        
    }
    
    
    func createPickerViewForTextFields(_ dropDown : Int) {
        
        
        if dropDown == FilterDropDownOptions.MedicalPlan.rawValue {
            pickerView.delegate = self
            activeArray = medicalPlansOptions
            selectedTextField = FilterDropDownOptions.MedicalPlan.rawValue
            MedicalPlansTextField.inputView = pickerView
        }
            
        else if dropDown == FilterDropDownOptions.Dosage.rawValue {
            pickerView.delegate = self
            activeArray = dosagesOptions
            selectedTextField = FilterDropDownOptions.Dosage.rawValue
            DosageTextField.inputView = pickerView
        }
            
            
        else if dropDown == FilterDropDownOptions.OrderBy.rawValue {
            pickerView.delegate = self
            activeArray = orderByOptions
            selectedTextField = FilterDropDownOptions.OrderBy.rawValue
            OrderByTextField.inputView = pickerView
        }
    }
    
    
    //MARK: TextField method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == MedicalPlansTextField {
            
            pickerView.isHidden = false
        }
            
        else if textField == DosageTextField {
            
            pickerView.isHidden = false
        }
            
        else if textField == OrderByTextField {
            
            pickerView.isHidden = false
        }
        
        pickerView.endEditing(true)
    }
    
    func configureTextFields() {
        
        MedicalPlansTextField.delegate = self
        DosageTextField.delegate = self
        OrderByTextField.delegate = self
    }
    
    
    func configureTableView() {
        MedicinesTableView.delegate = self;
        MedicinesTableView.dataSource = self;
        
        MedicinesTableView.rowHeight = UITableView.automaticDimension;
        MedicinesTableView.estimatedRowHeight = 110.0
        MedicinesTableView.separatorStyle = .none
        
        MedicinesTableView.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: "customMedicineCell")
    }
    
    
    func getDropDownOptions(){
        
        medicalPlanService.getMedicalPlanOptions { (result) in
            guard let medicalPlans = result else {return}
            
            medicalPlans.forEach { (medicalPlan) in
                self.medicalPlansOptions.append(medicalPlan.Name)
                
            }
            
        }
        
        dosageService.getDosageOptions { (result) in
            guard let dosages = result else {return}
            
            dosages.forEach { (dosage) in
                self.dosagesOptions.append(dosage.Amount.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", dosage.Amount) : String(dosage.Amount))
            }
            
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MedicineInformationViewController {
            
            
            destination.medicineID = self.medicinesArray[(MedicinesTableView.indexPathForSelectedRow?.row)!].MedicineID
            
            
            MedicinesTableView.deselectRow(at: MedicinesTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
    @objc func action() {
        view.endEditing(true)
    }
    
    
}


