import UIKit

class DriverMainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ResponseHandler {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    let simpelArray = ["one", "two", "three"]
    
    let restAPI = RestAPI()
    
    var userEmail: String!
    var authToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        restAPI.responseData = self
        
        if(userEmail != nil && authToken != nil){
            createUser()
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
        restAPI.get(authToken, Endpoint.DRIVERS + userEmail)
    }
    
    func onSuccess(_ response: NSDictionary) {
        
        //let endpoint = response.value(forKey: "endpoint") as! String
        
        //print(endpoint)
        
        /*
        
        switch endpoint{
        case Endpoint.CUSTOMERLOGIN:
            let firstName: String = response.value(forKey: "first_name") as! String
            let lastName: String = response.value(forKey: "last_name") as! String
            let password: String = response.value(forKey: "password") as! String
            
            let driver = Driver(firstName, lastName, userEmail, password, authToken)
            
            Driver.store(driver)
            
        case Endpoint.DRIVERORDERS.replacingOccurrences(of: "{id}", with: userEmail):
            debugPrint(response)
        default:
            break;
        }
 */
    }
    
    func onFailure(_ response: NSDictionary) {
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        User.delete()
        performSegue(withIdentifier: "DriverLoggedOut", sender: self)
    }
}
