import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Check if the user is logged in
        if(User.get() != nil){
            print("Logged in with userType: " + User.get()!)
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: User.get()! + "LoggedIn")
        } else {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "NotLoggedIn")
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

