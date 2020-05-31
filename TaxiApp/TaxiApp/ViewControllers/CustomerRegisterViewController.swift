import UIKit

class CustomerRegisterViewController: UIViewController, ResponseHandler,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    // Outlet declaration
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    //Test purpose
    @IBOutlet var profilePicture: UIImageView!
    let restAPI = RestAPI()
    var dataImage: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restAPI.responseData = self
        
        restAPI.download("/files", "/radu.jpg")
        
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
        
        dataImage = image.jpegData(compressionQuality: 1.0)!
    }
    
    @IBAction func register(_ sender: UIButton) {
        dismissKeyboard()
        
        // Get input
        let name: String = nameText.text!
        let lastName: String = lastNameText.text!
        let email: String = emailText.text!
        let password: String = passwordText.text!
        let pictureName: String = email + ".jpg"
        
        if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty){
            print("Error! Some values are empty")
            ToastView.shared.short(self.view, txt_msg: "Please enter all fields!")
            return
        }
        
        print("Performing registering with name: " + name + " " + lastName + ", email: " + email + ", password: " + password + ", picture: " + pictureName + ", status: " + "0")
        
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let parameters = ["first_name": name, "last_name": lastName, "email": email, "password": password, "profile_picture_path": pictureName, "status": 0] as [String : Any]
        
        restAPI.post(parameters, Endpoint.CUSTOMERS)
        restAPI.upload(dataImage, "/files", pictureName)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func dRegister(){
        performSegue(withIdentifier: "driverRegister", sender: self)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        print("---- SUCCESS ----")
        
        if(response["image"] != nil){
            let image = response["image"] as? UIImage
            profilePicture.image = image
        }
        
        //navigationController?.popToRootViewController(animated: true)
    }
    
    func onFailure() {
        print("---- FAILURE ----")
        ToastView.shared.short(self.view, txt_msg: "Error! Could not register")
    }
}
