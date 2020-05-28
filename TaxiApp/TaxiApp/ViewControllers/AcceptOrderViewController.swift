import UIKit

class AcceptOrderViewController: UIViewController, ResponseHandler{
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var pickupPoint: UILabel!
    @IBOutlet weak var destinationPoint: UILabel!
    @IBOutlet weak var fare: UILabel!
    
    var order: Order?
    
    let restAPI = RestAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restAPI.responseData = self

        orderNumber.text = "OrderNumber: \(order!.id!)"
        customer.text = "Customer: \(order!.customerEmail!)"
        pickupPoint.text = "PickupLocation: \(order!.pickup!)"
        destinationPoint.text = "Destination: \(order!.destination!)"
        fare.text = "Fare: \(order!.fare!)"
    }
    
    @IBAction func acceptOrder(_ sender: Any) {
        var address = Endpoint.ACCEPTORDER
        address = address.replacingOccurrences(of: "{id}", with: String(order!.id))
        address = address.replacingOccurrences(of: "{driverEmail}", with: User.getUserEmail()!)
        restAPI.patch(User.getUserAuthToken()!, address)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        let endpoint = response["endpoint"] as! String
        
        var address = Endpoint.ACCEPTORDER
        address = address.replacingOccurrences(of: "{id}", with: String(order!.id))
        address = address.replacingOccurrences(of: "{driverEmail}", with: User.getUserEmail()!)
        
        switch endpoint {
        case address:
            navigationController?.popToRootViewController(animated: true)
        default: break
        }
    }
    
    func onFailure() {
        ToastView.shared.long(self.view, txt_msg: "Error! Could not accept order")
    }
    
}
