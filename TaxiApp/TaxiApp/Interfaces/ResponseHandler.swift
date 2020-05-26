import Foundation

protocol ResponseHandler {
    
    // If the repsponse code is ok
    func onSuccess(_ response: Dictionary<String, Any>)
    
    // If the response code is not ok
    func onFailure()
}
