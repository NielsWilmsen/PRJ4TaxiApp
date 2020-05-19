import UIKit
import MapKit

class CustomerMainPageViewController: UIViewController, MKMapViewDelegate, ResponseHandler {
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var pickupInput: UITextField!
    @IBOutlet weak var destinationInput: UITextField!
    
    var locations: [CLPlacemark] = []
    
    var authToken: String!
    var userEmail: String!
    
    @IBAction func confirmLocation(_ sender: Any) {
        
        if(pickupInput.text == "" || destinationInput.text == "") {
            print("Pickup or destination input is empty")
        } else {
            performSegue(withIdentifier: "ConfirmLocation", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ConfirmLocation":
            let vc = segue.destination as! ConfirmOrderViewController
            vc.CLLPickup = locations[0]
            vc.CLLDestination = locations[1]            
        default:
            break
        }
    }
    
    @IBAction func searchLocation(_ sender: UIButton) {
        
        let pickup: String = pickupInput.text!
        let destination: String = destinationInput.text!
        
        print("Searching for location: " + pickup)
        
        if (pickup.isEmpty){
            print("Pickup is empty!")
            return
        }
        
        if (destination.isEmpty){
            print("Destination is empty!")
            return
        }
        
        getLocation(pickup)
        getLocation(destination)
    }
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        self.navigationItem.hidesBackButton = true;
        mapKit.delegate = self;
        setUpMapView()
        
        if(userEmail != nil && authToken != nil){
            createUser()
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
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
    
    func getLocation(_ address: String){
        
        let geoCoder = CLGeocoder()
        
        print(address)
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("ERROR! No locations found")
                    return
            }
            
            print(address)
            self.locations.append(placemarks.first!)
            self.createRoute(self.locations)
        }
        
    }
    
    func createRoute(_ placemarks: [CLPlacemark]) {
        
        if (locations.count != 2) { return }
        
        let pickupCoordinates: CLLocationCoordinate2D = placemarks[0].location!.coordinate
        let destinationCoordinates: CLLocationCoordinate2D = placemarks[1].location!.coordinate
                        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinates, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = placemarks[0].name
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = placemarks[1].name
        
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
                print("Error")
                return
            }
            
            let route = response.routes[0]
            
            let distance = route.distance
            
            print("\(distance / 1000)km")
            
            self.mapKit.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
            let rect = route.polyline.boundingMapRect
            
            let p1: MKMapPoint = MKMapPoint (pickupCoordinates);
            let p2: MKMapPoint = MKMapPoint (destinationCoordinates);

            // and make a MKMapRect using mins and spans
            let mapRect: MKMapRect = MKMapRect(x: fmin(p1.x,p2.x) - 100, y: fmin(p1.y,p2.y) - 100, width: fabs(p1.x-p2.x - 1000), height: fabs(p1.y-p2.y - 1000));
            
            self.mapKit.setRegion(MKCoordinateRegion(mapRect), animated: true)
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
    
        return renderer
    }
    
    func createUser(){
        let restAPI = RestAPI()
        
        restAPI.responseData = self
                
        restAPI.get(authToken!, Endpoint.CUSTOMERS + userEmail!)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        
        let firstName: String = response["first_name"] as! String
        let lastName: String = response["last_name"] as! String
        let password: String = response["password"] as! String
                
        let customer = Customer(firstName, lastName, userEmail, password, authToken)
                
        Customer.store(customer)
    }
    
    @IBAction func Logout(_ sender: Any) {
        User.delete()
        performSegue(withIdentifier: "CustomerLoggedOut", sender: self)
    }
    
    func onFailure(_ response: Dictionary<String, Any>) {
        print("FAILURE : " + response.description)
    }
}

extension CustomerMainPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        //print(error.localizedDescription)
    }
}
