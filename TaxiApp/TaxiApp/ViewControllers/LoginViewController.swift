import UIKit

class LoginViewController: UIViewController, ResponseHandler {
    
    var name: String!
    var password: String!
    
    var selectedUser = userType.CUSTOMER
    
    var authToken: String!
    var userEmail: String!
    
    // Outlet declaration
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Dismiss the keyboard when a user taps anywhere
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        // Sets the labels to be clickable
        registerLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.isUserInteractionEnabled = true
        
        registerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(register)))
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPassword)))
    }
    
    @IBAction func login(_ sender: UIButton){
        dismissKeyboard()
        name = nameText.text!
        password = passwordText.text!
        
        if(name.isEmpty || password.isEmpty){
            print("Error! Some values are empty")
            return
        }
        
        print("Performing login with name: " + name + ", password: " + password)
            
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let parameters = ["username": name, "password": password] as [String: String]
        
        restAPI.post(parameters, "/" + selectedUser.rawValue.lowercased() + "s/login")
    }
    
    @objc func register(sender: UITapGestureRecognizer){
        print("Opening " + selectedUser.rawValue + " register view")

        performSegue(withIdentifier: selectedUser.rawValue + "Register", sender: self)
    }
    
    @objc func forgotPassword(sender:
        UITapGestureRecognizer){
        print("Opening forgot password view")
        
        // TODO perform segue to forgot password screen
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func changeUser(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            selectedUser = userType.CUSTOMER
        case 1:
            selectedUser = userType.DRIVER
        default:
            selectedUser = userType.CUSTOMER
        }
    }
    
    func onSuccess(_ response: NSDictionary) {
        print("---- SUCCESS ----")
        
        authToken = response.object(forKey: "token") as? String
        userEmail = response.object(forKey: "email") as? String
                
        performSegue(withIdentifier: selectedUser.rawValue + "Login", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "CustomerLogin":
            let vc = segue.destination as! CustomerMainPageViewController
            vc.authToken = self.authToken
            vc.userEmail = self.userEmail
        case "DriverLogin":
            let vc = segue.destination as! DriverMainScreenViewController
            vc.authToken = self.authToken
            vc.userEmail = self.userEmail
        default:
            break
        }
    }
    
    func onFailure(_ response: NSDictionary) {
        print("---- FAILURE ----")
    }
    
    func match(_ a: String, _ b: String) -> Bool{
        return a == b
    }
}

enum userType: String {
    case CUSTOMER = "Customer"
    case DRIVER = "Driver"
}
