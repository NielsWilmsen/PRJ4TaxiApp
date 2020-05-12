import UIKit

class LoginViewController: UIViewController, ResponseHandler {
    
    var name: String!
    var password: String!
    
    // Outlet declaration
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        restAPI.post(parameters, "/customers/login")
    }
    
    @objc func register(sender: UITapGestureRecognizer){
        print("Opening register view")
        performSegue(withIdentifier: "register", sender: self)
    }
    
    @objc func forgotPassword(sender:
        UITapGestureRecognizer){
        print("Opening forgot password view")
        
        // TODO perform segue to forgot password screen
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func onSuccess(_ response: Data) {
        print("---- SUCCESS ----")
        performSegue(withIdentifier: "Login", sender: self)
    }
    
    func onFailure(_ response: Data) {
        print("---- FAILURE ----")
    }
    
    func match(_ a: String, _ b: String) -> Bool{
        return a == b
    }
}
