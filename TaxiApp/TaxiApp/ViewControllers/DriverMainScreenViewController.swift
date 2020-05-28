import UIKit

class DriverMainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ResponseHandler {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    var orderArray = [Int: Dictionary<String, Any>]()
    
    let restAPI = RestAPI()
    
    var userEmail: String!
    var authToken: String!
    
    var selectedOrder: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        restAPI.responseData = self
        
        // Check if the user just logged in or it was already logged in
        if(userEmail != nil && authToken != nil){
            createUser()
        } else {
            // Get orders with already logged in user
            getOrders()
        }
        
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
        
        let range = street.range(of: #"\w+ \d+"#, options: .regularExpression)
                
        cell.street.text = String(street[range!])
        
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
        case "OrderDetails":
            let vc = segue.destination as! OrderDetailsViewController
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
        let driver = order["driver_email"] as! String
        let id = order["ID"] as! Int
        let fare = order["fare"] as! Int
        let status = order["status"] as! Int
        
        selectedOrder = Order(pickup, destination, driver, customer, fare, id, status)
        
        performSegue(withIdentifier: "OrderDetails", sender: self)
    }
    
    func createUser(){
        restAPI.get(authToken!, Endpoint.DRIVERS + userEmail!)
    }
    
    func getOrders(){
        restAPI.get(User.getUserAuthToken()!, Endpoint.DRIVERORDERS.replacingOccurrences(of: "{id}", with: Driver.getUserEmail()!))
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        
        let endpoint = response["endpoint"] as! String
        
        if(userEmail == nil) {
            userEmail = Driver.getUserEmail()!
        }
        
        switch endpoint {
        case Endpoint.DRIVERS + userEmail!:
            let firstName: String = response["first_name"] as! String
            let lastName: String = response["last_name"] as! String
            let password: String = response["password"] as! String
            
            let driver = Driver(firstName, lastName, userEmail!, password, authToken!)

            Driver.store(driver)
            
            getOrders()
            
        case Endpoint.DRIVERORDERS.replacingOccurrences(of: "{id}", with: Driver.getUserEmail()!):
            for order in response {
                if(!order.key.elementsEqual("endpoint")){
                    orderArray[Int(order.key)!] = (order.value as! Dictionary<String, Any>)
                }
            }
            self.orderTableView.reloadData()
            
        default: break
        }
    }
    
    func onFailure() {
        print("--FAILURE--")
    }
    
    @IBAction func Logout(_ sender: Any) {
        User.delete()
        performSegue(withIdentifier: "DriverLoggedOut", sender: self)
    }
}
