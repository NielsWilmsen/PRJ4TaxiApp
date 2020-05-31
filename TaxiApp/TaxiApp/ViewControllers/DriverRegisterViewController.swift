import UIKit

class DriverRegisterViewController: UIViewController, ResponseHandler, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var brandText: UITextField!
    @IBOutlet weak var modelText: UITextField!
    @IBOutlet weak var licencePlateText: UITextField!
    @IBOutlet weak var colorText: UITextField!
    
    var dataImage: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
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
        let brand: String = brandText.text!
        let model: String = modelText.text!
        let color: String = colorText.text!
        let licencePlate: String = licencePlateText.text!
        let pictureName: String = email + ".jpg"
        
        if(name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || brand.isEmpty || model.isEmpty || color.isEmpty || licencePlate.isEmpty){
            print("Error! Some values are empty")
            ToastView.shared.short(self.view, txt_msg: "Please enter all fields!")
            return
        }
        
        print("Performing registering with name: " + name + ", lastname " + lastName + ", email: " + email + ", password: " + password + ", picture: " + pictureName)
        
        let restAPI = RestAPI()
        
        restAPI.responseData = self
        
        let driverParameters = ["first_name": name, "last_name": lastName, "email": email, "password": password, "status": 0, "profile_picture_path": pictureName] as [String : Any]
        let carParameters = ["license_plate": licencePlate, "brand": brand, "model": model, "color": color] as [String : String]
        
        restAPI.post(driverParameters, "/drivers")
        restAPI.post(carParameters, "/cars")
        restAPI.upload(dataImage, "/files", pictureName)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func onSuccess(_ response: Dictionary<String, Any>) {
        print("---- SUCCESS ----")
        navigationController?.popToRootViewController(animated: true)
    }
    
    func onFailure() {
        print("---- FAILURE ----")
        ToastView.shared.short(self.view, txt_msg: "Error! Could not register")
    }
}
