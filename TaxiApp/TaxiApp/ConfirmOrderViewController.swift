import UIKit
import MapKit

class ConfirmOrderViewController: UIViewController, ResponseHandler {

    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    
    var CLLPickup: CLPlacemark!
    var CLLDestination: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupLocation.text = CLLPickup.name
        destinationLocation.text = CLLDestination.name
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        let order = Order(CLLPickup, CLLDestination)
        
        let c = Customer("Niels", "Wilmsen", "test@test.com", "12345")
        let d = Driver("Niels", "Wilmsen", "test@test.com", "12345")
        
        order.finalize(c, d)
        
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let parameters = ["customer_email": order.customer.email, "driver_email": order.driver.email, "fare": "1", "pick_up_point": order.pickup.name!, "destination": order.destination.name!] as [String: String]
        
        restAPI.post(parameters, "/orders")
    }
    
    func onSuccess(_ response: Data) {
        
    }
    
    func onFailure(_ response: Data) {
        
    }
    
}
