import UIKit

class OrderDetailsViewController: UIViewController {

    var order: Order?
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var pickupPoint: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var driverEmail: UILabel!
    @IBOutlet weak var fare: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderNumber.text = "OrderNumber: \(order!.id!)"
        customerEmail.text = "Customer: \(order!.customerEmail!)"
        pickupPoint.text = "PickupLocation: \(order!.pickup!)"
        destination.text = "Destination: \(order!.destination!)"
        driverEmail.text = "Driver: \(order!.driverEmail!)"
        fare.text = "Fare: \(order!.fare!)"
    }
}
