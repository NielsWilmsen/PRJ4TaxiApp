
import Foundation

class Customer {
    
    var name: String!
    var lastName: String!
    var email: String!
    var password: String!
    
    init(_ name:String!, _ lastName:String!, _ email:String!, _ password:String!){
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
}
