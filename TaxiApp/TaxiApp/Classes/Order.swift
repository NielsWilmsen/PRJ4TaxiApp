import Foundation
import MapKit

class Order {
    
    var id: Int!
    var pickup: String!
    var destination: String!
    var customerEmail: String!
    var driverEmail: String!
    var fare: Int!
    var status: Int!
    
    init(_ pickup: String, _ destination: String, _ customer: String, _ driver: String, _ fare: Int, _ id: Int, _ status: Int){
        self.pickup = pickup
        self.destination = destination
        self.customerEmail = customer
        self.driverEmail = driver
        self.id = id
        self.fare = fare
        self.status = status
    }
    
}
