import Foundation

class Endpoint {
    static let CUSTOMERLOGIN = "/customers/login"
    static let DRIVERLOGIN = "/drivers/login"
    static let CUSTOMERS = "/customers/"
    static let DRIVERS = "/drivers/"
    static let DRIVERORDERS = "/drivers/{id}/orders"
    static let NEWORDERS = "/ordersInRange/{range}/{driversLon}/{driversLat}"
    static let ACCEPTORDER = "/orders/acceptOrder/{id}/{driverEmail}"
    static let CANCELORDER = "/orders/cancelOrder/{id}"
}
