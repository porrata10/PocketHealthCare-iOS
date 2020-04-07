







import UIKit

class MedicineSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var MedicineSearchBar: UISearchBar!
    
    @IBOutlet weak var MedicinesTableView: UITableView!
    
    let medicalPlanService = MedicalPlanService()
    let medicineService = MedicineService()
    var medicineArray:[MedicineModel] = [MedicineModel]()
    var filterMedicineArray:[MedicineModel] = [MedicineModel]()
    var isSearching = false
    var medicineID = 0
    var selectedMedicineID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getMedicineCellsInformation()
        configureTableView()
        configureSearchBar()
    }
    
    
    
    // MARK: TableView methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterMedicineArray.count
        } else {
            return medicineArray.count
        }
    }
    
    
    // When the user is searching it displays the filtered rows 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MedicinesTableView.dequeueReusableCell(withIdentifier: "customMedicineCell", for: indexPath) as! MedicineTableViewCell
        
        if isSearching {
            
            cell.MedicineNameLabel.text = filterMedicineArray[indexPath.row].Name
            cell.MedicinePurposeLabel.text = filterMedicineArray[indexPath.row].Purpose
            cell.MedicineCategoryLabel.text = filterMedicineArray[indexPath.row].Category
            
        } else {
            
            cell.MedicineNameLabel.text = medicineArray[indexPath.row].Name
            cell.MedicinePurposeLabel.text = medicineArray[indexPath.row].Purpose
            cell.MedicineCategoryLabel.text = medicineArray[indexPath.row].Category
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FromSearchBarToMedicineInformation", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func getMedicineCellsInformation(){
        medicineService.getMedicines { (results) in
            guard let medicines = results else {return}
            
            medicines.forEach { (medicine) in
                self.medicineArray.append(medicine)
            }
            
            self.MedicinesTableView.reloadData()
        }
    }
    
    
    // MARK: Search Bar method
    
    // When the user is searhcing the table view filters
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            isSearching = false
            MedicinesTableView.reloadData()
        } else {
            isSearching = true
            filterMedicineArray = medicineArray.filter({$0.Name.contains(searchBar.text ?? "")})
            
            MedicinesTableView.reloadData()
        }
    }
    
    
    /// Sets the delegate for the searchbar
    func configureSearchBar() {
        
        MedicineSearchBar.delegate = self
    }
    
    
    /// Configures table view style and registers nib file for custom cell
    func configureTableView() {
        
        MedicinesTableView.delegate = self
        MedicinesTableView.dataSource = self
        
        MedicinesTableView.rowHeight = 120.0
        MedicinesTableView.estimatedRowHeight = 120.0;
        MedicinesTableView.separatorStyle = .none;
        
        MedicinesTableView.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: "customMedicineCell")
    }
    
    
    /**
     Performs a segue to pass a medicine id to MedicineInformationViewController
     
     # Important Notes#
     1. If the user is searching for a medicine the table view will be filtered and pass the id of the filtered table view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MedicineInformationViewController {
            
            if isSearching {
                
                destination.medicineID =  filterMedicineArray[(MedicinesTableView.indexPathForSelectedRow?.row)!].MedicineID
            }
                
            else {
                destination.medicineID =  medicineArray[(MedicinesTableView.indexPathForSelectedRow?.row)!].MedicineID
            }
            
            MedicinesTableView.deselectRow(at: MedicinesTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
}

/**
 When applying a ui color to an element it can accept hexadecimal values
 
 # Usage Example #
 
 ````
 view.backgroundColor = UIColor(hex: 0xEDEFF1)
 ```
 */

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

