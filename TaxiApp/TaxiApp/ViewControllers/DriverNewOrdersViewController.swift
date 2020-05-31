import UIKit
import MapKit

class DriverNewOrdersViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, ResponseHandler{
    
    @IBOutlet weak var newOrderTable: UITableView!
    
    var orderArray = [Int: Dictionary<String, Any>]()
    
    let restAPI = RestAPI()
    
    let manager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var selectedOrder: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.requestLocation()
        
        newOrderTable.dataSource = self
        newOrderTable.delegate = self
        
        restAPI.responseData = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRow", for: indexPath) as! OrderTableViewCell
        
        let street = (orderArray[indexPath.row]!["pick_up_point"] as! String)
        
        if let range = street.range(of: #"\w+ \d+"#, options: .regularExpression) {
            cell.street.text = String(street[range])
        } else {
            cell.street.text = street
        }
        
        var image: UIImage!
        
        switch orderArray[indexPath.row]!["status"] as! Int {
        case 0:
            image = UIImage(named: "notAssignedIcon")
        case 1:
            image = UIImage(named: "awaitIcon")
        case 2:
            image = UIImage(named: "ongoingIcon")
        case 3:
            image = UIImage(named: "finishedIcon")
        case 4:
            image = UIImage(named: "cancelledIcon")
        default:
            image = UIImage(named: "notAssignedIcon")
        }
        
        cell.status.image = image
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "acceptOrder":
            let vc = segue.destination as! AcceptOrderViewController
            vc.order = self.selectedOrder
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt IndexPath: IndexPath){
        print(orderArray[IndexPath.row]!["pick_up_point"] as! String)
        
        let order = orderArray[IndexPath.row]!
        let pickup = order["pick_up_point"] as! String
        let destination = order["destination"] as! String
        let customer = order["customer_email"] as! String
        let driver = ""
        let id = order["ID"] as! Int
        let fare = order["fare"] as! Int
        let status = order["status"] as! Int
        
        selectedOrder = Order(pickup, destination, customer, driver, fare, id, status)
        
        performSegue(withIdentifier: "acceptOrder", sender: self)
    }
    
    func getOrders(){
        
        var address = Endpoint.NEWORDERS
        address = address.replacingOccurrences(of: "{range}", with: "1")
        address = address.replacingOccurrences(of: "{driversLon}", with: "\(currentLocation.coordinate.longitude)")
        address = address.replacingOccurrences(of: "{driversLat}", with: "\(currentLocation.coordinate.latitude)")
        
        restAPI.get(User.getUserAuthToken()!, address)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        
        let endpoint = response["endpoint"] as! String
        
        var address = Endpoint.NEWORDERS
        address = address.replacingOccurrences(of: "{range}", with: "1")
        address = address.replacingOccurrences(of: "{driversLon}", with: "\(currentLocation.coordinate.longitude)")
        address = address.replacingOccurrences(of: "{driversLat}", with: "\(currentLocation.coordinate.latitude)")
        
        switch endpoint {
        case address:
            for order in response {
                if(!order.key.elementsEqual("endpoint")){
                    orderArray[Int(order.key)!] = (order.value as! Dictionary<String, Any>)
                }
            }
            self.newOrderTable.reloadData()
            
        default: break
        }
    }
    
    func onFailure() {
        print("--FAILURE--")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            currentLocation = location
            getOrders()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
