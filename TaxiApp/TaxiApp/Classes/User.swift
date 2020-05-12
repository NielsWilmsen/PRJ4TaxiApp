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
}
