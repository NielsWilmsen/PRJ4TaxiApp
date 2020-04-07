import UIKit

class LoginViewController: UIViewController {
        
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
        let name: String = nameText.text!
        let password: String = passwordText.text!
        
        if(name.isEmpty || password.isEmpty){
            print("Error! Some values are empty")
            return
        }
        
        print("Performing login with name: " + name + ", password: " + password)
        
        // TODO login request to the API
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
}
