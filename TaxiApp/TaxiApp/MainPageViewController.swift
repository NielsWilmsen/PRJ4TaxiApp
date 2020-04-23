import UIKit
import MapKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var pickupInput: UITextField!
    @IBOutlet weak var destinationInput: UITextField!
    
    var matchingItems:[MKMapItem] = []
    
    @IBAction func searchLocation(_ sender: UIButton) {
        
        let pickup: String = pickupInput.text!
        let destination: String = pickupInput.text!
        
        print("Searching for location: " + pickup)
        
        if (pickup.isEmpty){
            print("Pickup is empty!")
            return
        }
        
        if (destination.isEmpty){
            print("Destination is empty!")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let pickupCoordinates: CLLocationCoordinate2D = self.getLocation(pickup)!
            let destinationCoordinates: CLLocationCoordinate2D = self.getLocation(destination)!
            
            let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinates, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = "Times Square"
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = "Empire State Building"
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            
            self.mapKit.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            // 8.
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.mapKit.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapKit.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
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
    
    func getLocation(_ input: String) -> CLLocationCoordinate2D? {
        
        var loc: CLLocationCoordinate2D? = nil
        
        guard let mapView = mapKit else { return nil}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = input
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems.append(response.mapItems[0])
            
            loc = response.mapItems[0].placemark.coordinate
        }
        while(loc == nil){
            
        }
        return loc
    }
    
    func getAddress(_ location: CLLocation) -> String {
        var address: String = ""
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
                
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    address = placemark.name!
                } else {
                    print("No Matching Addresses Found")
                }
            }
        }
        return address;
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}

extension MainPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("jow")
        
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 400, longitudinalMeters: 400)
        mapKit.setRegion(coordinateRegion, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
                
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.pickupInput.text = placemark.name!
                } else {
                    print("No Matching Addresses Found")
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("sike")
        
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
}
