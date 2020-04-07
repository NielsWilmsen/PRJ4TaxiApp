import UIKit

class DriverRegisterViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var brandText: UITextField!
    @IBOutlet weak var modelText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @IBAction func register(_ sender: UIButton) {
        dismissKeyboard()
        
        // Get input
        let name: String = nameText.text!
        let lastName: String = lastNameText.text!
        let email: String = emailText.text!
        let password: String = passwordText.text!
        let brand: String = brandText.text!
        let model: String = modelText.text!
        
        if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || brand.isEmpty || model.isEmpty){
            print("Error! Some values are empty")
            return
        }
        
        print("Performing registering with name: " + name + " " + lastName + ", email: " + email + ", password: " + password)
        
        // TODO register request to the API
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
