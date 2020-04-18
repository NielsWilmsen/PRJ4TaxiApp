import UIKit
import MapKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var locationInput: UITextField!
    
    var matchingItems:[MKMapItem] = []
    
    @IBAction func searchLocation(_ sender: UIButton) {
        
        let input: String = locationInput.text!
        
        print("Searching for location: " + input)
        
        if (input.isEmpty){
            print("Input is empty!")
            return
        }
        
        getLocations(input)
    }
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        
        setUpMapView()
    }
    
    func setUpMapView() {
        mapKit.showsUserLocation = true
        mapKit.showsCompass = true
        mapKit.showsScale = true
        currentLocation()
    }
    
    func currentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
    }
    
    func getLocations(_ input: String) {
        guard let mapView = mapKit else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = input
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            
            // TODO do something with the location information
            
            for location in self.matchingItems {
                let pm = location.placemark
                print(pm.coordinate.latitude)
                print(pm.coordinate.longitude)
            }
        }
    }
}

extension MainPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 400, longitudinalMeters: 400)
        mapKit.setRegion(coordinateRegion, animated: true)
        //locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
