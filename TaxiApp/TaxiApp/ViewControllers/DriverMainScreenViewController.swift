import UIKit

class DriverMainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ResponseHandler {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    var simpelArray = [Dictionary<String, Any>]()
    
    let restAPI = RestAPI()
    
    var userEmail: String!
    var authToken: String!
    
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
        return simpelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRow", for: indexPath)
        
        cell.textLabel!.text = simpelArray[indexPath.row]
        
        return cell
    }
    
    func createUser(){
        print("\(authToken!), \(userEmail!)")
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
                //simpelArray.append()
            }
        default: break
        }
        
        /*
        switch (test){
        case Endpoint.CUSTOMERLOGIN:
            let firstName: String = response["first_name"] as! String
            let lastName: String = response["last_name"] as! String
            let password: String = response["password"] as! String
            
            let driver = Driver(firstName, lastName, userEmail!, password, authToken!)
            
            Driver.store(driver)
            
            getOrders()
            
        case Endpoint.DRIVERORDERS.replacingOccurrences(of: "{id}", with: User.getUserEmail()!):
            debugPrint(response)
        default:
            break;
        }
 */
        
    }
    
    func onFailure() {
        print("--FAILURE--")
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        User.delete()
        performSegue(withIdentifier: "DriverLoggedOut", sender: self)
    }
}
