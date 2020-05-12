import Foundation

protocol ResponseHandler {
    
    // If the repsponse code is ok
    func onSuccess(_ response: NSDictionary)
    
    // If the response code is not ok
    func onFailure(_ response: NSDictionary)
}
