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
        UserDefaults.standard.set(user.email, forKey: "Email")
        UserDefaults.standard.set(user.authToken, forKey: "")
    }
    
    static func getUserType() -> String?{
        return UserDefaults.standard.string(forKey: "User")
    }
    
    static func getUserEmail() -> String?{
        return UserDefaults.standard.string(forKey: "Email")
    }
    
    static func getUserAuthToken() -> String?{
        return UserDefaults.standard.string(forKey: "AuthToken")
    }
    
    static func delete() {
        UserDefaults.standard.removeObject(forKey: "User")
        UserDefaults.standard.removeObject(forKey: "Email")
        UserDefaults.standard.removeObject(forKey: "AuthToken")
    }
}
