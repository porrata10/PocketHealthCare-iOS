







import UIKit

class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var doctorsTableView: UITableView!
    @IBOutlet weak var MedicalPlanTextField: UITextField!
    @IBOutlet weak var SpecialtyTextField: UITextField!
    @IBOutlet weak var TownTextField: UITextField!
    
    enum FilterDropDownOptions : Int {
        case MedicalPlan = 1
        case Specialty = 2
        case Town = 3
    }
    
    enum DefaultDropDownOptions : String {
        case MedicalPlan = "Medical Plan"
        case Specialty = "Specialty"
        case Town = "Town"
    }
    
    var doctorArray:[DoctorModel] = [DoctorModel]()
    let medicalPlanService = MedicalPlanService()
    let doctorService = DoctorService()
    var medicalPlanOptions : [String] = ["Medical Plan"]
    var specialtyOptions : [String] = ["Specialty"]
    var townsOptions : [String] = ["Town"]
    var activeArray : [String] = []
    var selectedTextField : Int = 0
    var medicalPlanOption : String = ""
    var specialtyOption : String = ""
    var townOption : String = ""
    
    var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SetDropDowns()
        getdoctorCellInformation()
        configureTableView()
        setUpTextFields()
    }
    
    // MARK: IBActions
    
    @IBAction func medicalPlanDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    @IBAction func specialtyDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    @IBAction func townsDropDownSelected(_ sender: UITextField) {
        
        self.createPickerView(sender.tag)
    }
    
    
    // MARK: TableView methods
    
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    
    func getdoctorCellInformation() {
        doctorService.getDoctors { (results) in
            guard let doctors = results else {return}
            
            doctors.forEach { (doctor) in
                self.doctorArray.append(doctor)
                self.doctorsTableView.reloadData()
            }
        }
    }
    
    
    // MARK: PickerView methods
    
    
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
                
                MedicalPlanTextField.text = DefaultDropDownOptions.MedicalPlan.rawValue
                medicalPlanOption = ""
            }
                
            else{
                
                MedicalPlanTextField.text = activeArray[row]
                medicalPlanOption = activeArray[row]
            }
            
            self.pickerView.isHidden = true
            MedicalPlanTextField.resignFirstResponder()
        }
            
        else if selectedTextField == FilterDropDownOptions.Specialty.rawValue {
            
            if activeArray[row] == DefaultDropDownOptions.Specialty.rawValue{
                
                SpecialtyTextField.text = DefaultDropDownOptions.Specialty.rawValue
                specialtyOption = ""
            }
                
            else{
                
                SpecialtyTextField.text = activeArray[row]
                specialtyOption = activeArray[row]
            }
            
            self.pickerView.isHidden = true
            SpecialtyTextField.resignFirstResponder()
        }
            
            
        else if selectedTextField == FilterDropDownOptions.Town.rawValue {
            
            if activeArray[row] == DefaultDropDownOptions.Town.rawValue{
                
                TownTextField.text = DefaultDropDownOptions.Town.rawValue
                townOption = ""
            }
                
            else{
                
                TownTextField.text = activeArray[row]
                townOption = activeArray[row]
            }
            
            self.pickerView.isHidden = true
            TownTextField.resignFirstResponder()
        }
        
        
        // Getting the data from the database with the selected values from the pickerview
        doctorService.searchForDoctor(specialty: specialtyOption, city: townOption, plan: medicalPlanOption) { (result) in
            guard let doctors = result else {return}
            
            
            self.doctorArray = []
            doctors.forEach { (doctor) in
                self.doctorArray.append(doctor)
            }
            
            self.doctorsTableView.reloadData()
        }
        
        self.pickerView.endEditing(true)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func createPickerView(_ dropDown : Int) {
        
        if dropDown == FilterDropDownOptions.MedicalPlan.rawValue {
            pickerView.delegate = self
            activeArray = medicalPlanOptions
            selectedTextField = FilterDropDownOptions.MedicalPlan.rawValue
            MedicalPlanTextField.inputView = pickerView
        }
            
        else if dropDown == FilterDropDownOptions.Specialty.rawValue {
            pickerView.delegate = self
            activeArray = specialtyOptions
            selectedTextField = FilterDropDownOptions.Specialty.rawValue
            SpecialtyTextField.inputView = pickerView
        }
            
            
        else if dropDown == FilterDropDownOptions.Town.rawValue {
            pickerView.delegate =  self
            activeArray = townsOptions
            selectedTextField = FilterDropDownOptions.Town.rawValue
            TownTextField.inputView = pickerView
        }
    }
    
    
    //MARK: TextField method
    
    
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
    
    
    func SetDropDowns() {
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
    
    
    func configureTableView() {
        
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        
        doctorsTableView.rowHeight = UITableView.automaticDimension;
        doctorsTableView.estimatedRowHeight = 120.0;
        doctorsTableView.separatorStyle = .none;
        
        
        let nibName = UINib(nibName: "DoctorTableViewCell", bundle: nil)
        doctorsTableView.register(nibName, forCellReuseIdentifier:"doctorViewCell")
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DoctorInformationViewController{
            destination.doctorID = doctorArray[(doctorsTableView.indexPathForSelectedRow?.row)!].DoctorID
            doctorsTableView.deselectRow(at: doctorsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
    @objc func action() {
        view.endEditing(true)
    }
    
}


