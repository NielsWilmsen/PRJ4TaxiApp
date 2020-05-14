import Foundation

class User {
    
    var authToken: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var password: String!
    
    init(_ firstName: String, _ lastName: String, _ email: String, _ password: String, _ authToken: String){
        
        self.authToken = authToken
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        
    }
    
    static func store(_ user: User) {
        
        UserDefaults.standard.set(String(describing: type(of: user)), forKey: "User")
        
        /*
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: "User")
        } catch let error {
            print(error)
        }
 */
    }
    
    static func get() -> String?{
        
        /*
        guard let user = UserDefaults.standard.data(forKey: "User") else {
            return nil
        }
        do {
            let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(user) as? User
            return data
        } catch let error {
            print(error)
        }
 */
        
        return UserDefaults.standard.string(forKey: "User")
    }
    
    static func delete() {
        UserDefaults.standard.removeObject(forKey: "User")
    }
}
