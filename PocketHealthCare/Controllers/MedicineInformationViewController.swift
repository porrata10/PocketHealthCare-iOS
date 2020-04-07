







import UIKit

class MedicineInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MedicineNameUIView: UIView!
    
    @IBOutlet weak var CoverageTableViewUnderlay: UIView!
    @IBOutlet weak var MedicineDescriptionUIView: UIView!
    @IBOutlet weak var MedicineCovertHeadersUIView: UIView!
    @IBOutlet weak var MedicineNameLabel: UILabel!
    @IBOutlet weak var MedicinePurposeLabel: UILabel!
    @IBOutlet weak var MedicineDescriptionLabel: UILabel!
    @IBOutlet weak var MedicineCategoryLabel: UILabel!
    @IBOutlet weak var MedicineCovertTableView: UITableView!
    
    
    let medicineService = MedicineService()
    var medicineCovertsArray: [MedicalPlanCovertDosageModel]  = [MedicalPlanCovertDosageModel]()
    var medicineID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        makeUIViewsCornersRounded()
        displayMedicineInformation()
    }
    
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return medicineCovertsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = MedicineCovertTableView.dequeueReusableCell(withIdentifier: "customMedicineCovertCell", for: indexPath) as! MedicineCovertTableViewCell
        cell.covert.text = medicineCovertsArray[indexPath.row].Covert
        cell.medicalPlan.text = medicineCovertsArray[indexPath.row].MedicalPlan
        cell.dosage.text = String(medicineCovertsArray[indexPath.row].DosageAmount)
        
        
        return cell
    }
    
    
    /// Configures table view style and registers nib file for custom cell
    func configureTableView() {
        
        MedicineCovertTableView.delegate = self
        MedicineCovertTableView.dataSource = self
        
        MedicineCovertTableView.rowHeight = UITableView.automaticDimension;
        MedicineCovertTableView.estimatedRowHeight = 90.0;
        MedicineCovertTableView.allowsSelection =  false
        
        MedicineCovertTableView.register(UINib(nibName: "MedicineCovertTableViewCell", bundle: nil), forCellReuseIdentifier: "customMedicineCovertCell")
    }
    
    func makeUIViewsCornersRounded() {
        
        MedicineCovertHeadersUIView.conrnerRadius(usingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        
        CoverageTableViewUnderlay.layer.cornerRadius = 10;
        CoverageTableViewUnderlay.layer.masksToBounds = true;
        
        MedicineNameUIView.layer.cornerRadius = 10;
        MedicineNameUIView.layer.masksToBounds = true;
        
        MedicineDescriptionUIView.layer.cornerRadius = 10;
        MedicineDescriptionUIView.layer.masksToBounds = true;
    }
    
    
    func displayMedicineInformation() {
        
        medicineService.getMedicineInformationByID(id: medicineID) { (result) in
            
            guard let medicine = result else {return}
            
            self.MedicineNameLabel.text = medicine.MedicineInformation.Name
            self.MedicineCategoryLabel.text = medicine.MedicineInformation.Category
            self.MedicineDescriptionLabel.text = medicine.MedicineInformation.Description
            self.MedicinePurposeLabel.text = medicine.MedicineInformation.Purpose
            
            medicine.MedicalPlanDosage.forEach { (medicineCoverts) in
                self.medicineCovertsArray.append(medicineCoverts)
            }
            
            self.MedicineCovertTableView.reloadData()
        }
        
    }
}


/// Can make a specific corner of a uiview rounded
extension UIView {
    
    func conrnerRadius(usingCorners corners: UIRectCorner, cornerRadii: CGSize){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
}


