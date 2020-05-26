import UIKit

class DriverRegisterViewController: UIViewController, ResponseHandler {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var brandText: UITextField!
    @IBOutlet weak var modelText: UITextField!
    @IBOutlet weak var licencePlateText: UITextField!
    @IBOutlet weak var colorText: UITextField!
    
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
        let color: String = colorText.text!
        let licencePlate: String = licencePlateText.text!
        
        if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || brand.isEmpty || model.isEmpty || color.isEmpty || licencePlate.isEmpty){
            print("Error! Some values are empty")
            return
        }
        
        print("Performing registering with name: " + name + " " + lastName + ", email: " + email + ", password: " + password)
        
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let driverParameters = ["first_name": name, "last_name": lastName, "email": email, "password": password] as [String : String]
        let carParameters = ["license_plate": licencePlate, "brand": brand, "model": model, "color": color] as [String : String]
        
        restAPI.post(driverParameters, "/drivers")
        restAPI.post(carParameters, "/cars")
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        print("---- SUCCESS ----")
    }
    
    func onFailure(_ response: Dictionary<String, Any>) {
        print("---- FAILURE ----")
    }
}
