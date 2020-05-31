import UIKit

class OrderDetailsViewController: UIViewController, ResponseHandler {

    var order: Order?
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var pickupPoint: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var driverEmail: UILabel!
    @IBOutlet weak var fare: UILabel!
    
    let restAPI = RestAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restAPI.responseData = self

        orderNumber.text = "OrderNumber: \(order!.id!)"
        customerEmail.text = "Customer: \(order!.customerEmail!)"
        pickupPoint.text = "PickupLocation: \(order!.pickup!)"
        destination.text = "Destination: \(order!.destination!)"
        driverEmail.text = "Driver: \(order!.driverEmail!)"
        fare.text = "Fare: \(order!.fare!)"
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        var address = Endpoint.CANCELORDER
        address = address.replacingOccurrences(of: "{id}", with: String(order!.id))
        restAPI.patch(User.getUserAuthToken()!, address)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        let endpoint = response["endpoint"] as! String
        
        var address = Endpoint.CANCELORDER
        address = address.replacingOccurrences(of: "{id}", with: String(order!.id))
        
        switch endpoint {
        case address:
            navigationController?.popToRootViewController(animated: true)
        default: break
        }
        
    }
    
    func onFailure() {
        ToastView.shared.long(self.view, txt_msg: "Error! Could not cancel order")
    }
}
