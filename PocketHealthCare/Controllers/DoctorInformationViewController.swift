







import UIKit
import MapKit

class DoctorInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var DoctorNameLabel: UILabel!
    @IBOutlet weak var DoctorSpecialtyLabel: UILabel!
    @IBOutlet weak var DoctorTownLabel: UILabel!
    @IBOutlet weak var DoctorMedicalPlansTableView: UITableView!
    @IBOutlet weak var DoctorAddressLabel: UILabel!
    @IBOutlet weak var DoctorAddress2Label: UILabel!
    @IBOutlet weak var DoctorDirectionButton: UIButton!
    @IBOutlet weak var DoctorCellView: UIView!
    @IBOutlet weak var DirectionsCellView: UIView!
    
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    var doctorID = 0
    let doctorService = DoctorService()
    var medicalPlans:[MedicalPlanModel] = [MedicalPlanModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xEDEFF1)
        
        
        displayDoctorInformation()
        setDoctorMedicalPlans()
        configureTableView()
        makeDirectionsButtonCornersRounded()
        makeUIViewsCornersRounded()
    }
    
    
    @IBAction func DoctorDirectionButtonPressed(_ sender: Any) {
        let regionDistance: CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = "Doctor's Office"
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  medicalPlans.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DoctorMedicalPlansTableView.dequeueReusableCell(withIdentifier: "DoctorMedicalPlanCustomCell") as! DoctorMedicalPlanTableViewCell
        
        cell.medicalPlanLabel.text = medicalPlans[indexPath.row].Name
        
        return cell
    }
    
    
    func configureTableView() {
        
        DoctorMedicalPlansTableView.delegate = self
        DoctorMedicalPlansTableView.dataSource = self
        DoctorMedicalPlansTableView.rowHeight = UITableView.automaticDimension;
        DoctorMedicalPlansTableView.estimatedRowHeight = 120.0
        DoctorMedicalPlansTableView.separatorStyle = .none
        DoctorMedicalPlansTableView.allowsSelection =  false
        
        DoctorMedicalPlansTableView.layer.cornerRadius = 10;
        DoctorMedicalPlansTableView.layer.masksToBounds = true;
        
        
        let nibName = UINib(nibName: "DoctorMedicalPlanTableViewCell", bundle: nil)
        DoctorMedicalPlansTableView.register(nibName, forCellReuseIdentifier:"DoctorMedicalPlanCustomCell")
    }
    
    
    func setDoctorMedicalPlans(){
        doctorService.getDoctorInformationByID(id: doctorID) { (result) in
            guard let doctorInformation = result else {return}
            
            doctorInformation.MedicalPlans.forEach { (medicalPlan) in
                self.medicalPlans.append(medicalPlan)
                self.DoctorMedicalPlansTableView.reloadData()
                
            }
            
        }
    }
    
    
    func makeDirectionsButtonCornersRounded() {
        
        DoctorDirectionButton.layer.cornerRadius = DoctorDirectionButton.bounds.height/2
    }
    
    
    func displayDoctorInformation() {
        
        doctorService.getDoctorInformationByID(id: doctorID) { (result) in
            guard let doctorInformation = result else {return}
            
            self.DoctorNameLabel.text = doctorInformation.DoctorsInformation.Name
            self.DoctorSpecialtyLabel.text = doctorInformation.DoctorsInformation.Specialty
            self.DoctorTownLabel.text = doctorInformation.DoctorsInformation.City
            self.DoctorAddressLabel.text = "\(doctorInformation.DoctorsInformation.Address1) \(doctorInformation.DoctorsInformation.Address2)"
            self.DoctorAddress2Label.text = "\(doctorInformation.DoctorsInformation.City), \(doctorInformation.DoctorsInformation.State), \(doctorInformation.DoctorsInformation.ZipCode)"
            
            self.latitude = doctorInformation.DoctorsInformation.Latitude
            self.longitude = doctorInformation.DoctorsInformation.Longitude
        }
    }
    
    
    func makeUIViewsCornersRounded() {
        
        DoctorCellView.layer.cornerRadius = 10;
        DoctorCellView.layer.masksToBounds = true;
        
        DirectionsCellView.layer.cornerRadius = 10;
        DirectionsCellView.layer.masksToBounds = true;
    }
}
