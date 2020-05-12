import Foundation
import MapKit

class Order {
    
    var pickup: CLPlacemark!
    var destination: CLPlacemark!
    var customer: Customer!
    var driver: Driver!
    
    init(_ pickup: CLPlacemark, _ destination: CLPlacemark){
        self.pickup = pickup
        self.destination = destination
    }
    
    func finalize(_ customer: Customer, _ driver: Driver){
        self.customer = customer
        self.driver = driver
    }
    
}
