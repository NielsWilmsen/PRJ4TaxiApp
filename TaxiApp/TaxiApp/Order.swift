
import Foundation
import MapKit

class Order {
    
    var pickup: CLLocation!
    var destination: CLLocation!
    var customer: Customer!
    var driver: Driver!
    var time: Date!
    
    init(_ pickup: CLLocation, _ destination: CLLocation){
        self.pickup = pickup
        self.destination = destination
    }
    
    func finalize(_ customer: Customer, _ driver: Driver){
        self.customer = customer
        self.driver = driver
        self.time = Date()
    }
    
}
