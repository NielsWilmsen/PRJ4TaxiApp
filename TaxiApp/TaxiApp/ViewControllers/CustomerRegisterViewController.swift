import UIKit

class CustomerRegisterViewController: UIViewController, ResponseHandler,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    // Outlet declaration
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    //Test purpose
    @IBOutlet var profilePicture: [UIImageView]!
    let restAPI = RestAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss the keyboard when a user taps anywhere
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    //This is the function to open the camera
    @IBAction func takePicture(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    //This is the function that takes the image and processes it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        //Just to test, I added an image view to show the image
        let myImageView:UIImageView = UIImageView()
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myImageView.frame.size.width = 200
        myImageView.frame.size.height = 200
        myImageView.center = self.view.center
        myImageView.image = image
        view.addSubview(myImageView)
    }
    
    @IBAction func register(_ sender: UIButton) {
        dismissKeyboard()
        
        // Get input
        let name: String = nameText.text!
        let lastName: String = lastNameText.text!
        let email: String = emailText.text!
        let password: String = passwordText.text!
        
        if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty){
            print("Error! Some values are empty")
            ToastView.shared.short(self.view, txt_msg: "Error! Some values are empty")
            return
        }
        
        print("Performing registering with name: " + name + " " + lastName + ", email: " + email + ", password: " + password)
        
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let parameters = ["first_name": name, "last_name": lastName, "email": email, "password": password] as [String : String]
        
        restAPI.post(parameters, Endpoint.CUSTOMERS)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func dRegister(){
        performSegue(withIdentifier: "driverRegister", sender: self)
    }
    
    func onSuccess(_ response: NSDictionary) {
        print("---- SUCCESS ----")
    }
    
    func onFailure(_ response: NSDictionary) {
        print("---- FAILURE ----")
        
    }
}
