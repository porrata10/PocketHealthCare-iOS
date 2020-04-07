







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
        
        
        SetDoctorCell()
        configureTableView()
        configureSearchBar()
    }
    
    // MARK: TableView methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDoctorArray.count
        }else {
            return doctorArray.count
        }
    }
    
    
    // When the user is searching it displays the filtered rows 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorsTableView.dequeueReusableCell(withIdentifier: "doctorViewCell") as! DoctorTableViewCell
        
        if isSearching {
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "SearchBarToDoctorInformation", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
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
    
    
    // MARK: Search Bar method
    
    
    // When the user is searhcing the table view filters
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
    
    /// Sets the delegate for the searchbar
    func configureSearchBar() {
        
        doctorSearchBar.delegate = self
    }
    
    
    /// Configures table view style and registers nib file for custom cell
    func configureTableView() {
        
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        doctorsTableView.rowHeight = UITableView.automaticDimension
        doctorsTableView.estimatedRowHeight = 120.0
        doctorsTableView.separatorStyle = .none
        
        let nibName = UINib(nibName: "DoctorTableViewCell", bundle: nil)
        doctorsTableView.register(nibName, forCellReuseIdentifier:"doctorViewCell")
    }
    
    
    
    /**
     Performs a segue to pass a doctor id to DoctorInformationViewController
     
     # Important Notes#
     1. If the user is searching for a doctor the table view will be filtered and pass the id of the filtered table view
     */
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
    
}


