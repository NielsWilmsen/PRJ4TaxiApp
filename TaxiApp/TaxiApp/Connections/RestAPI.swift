import Foundation
import Alamofire

class RestAPI {
    
    var responseData: ResponseHandler?
    var urlString = "https://taxi-backend.eu-gb.mybluemix.net"
    
    func post(_ parameters: [String: String], _ address: String){
        let endPoint: String = urlString + address
        print("POST request to: " + endPoint)
        AF.request(endPoint,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print()
                switch response.result {
                case .success(let JSON):
                    print("Post request successful")
                    let parsedResponse = JSON as! NSDictionary
                    parsedResponse.setValue("endpoint", forKey: response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: ""))
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    self.responseData?.onFailure(error as! NSDictionary)
                }
        }
    }
    
    func get(_ authToken: String, _ address: String){
        let endPoint: String = urlString + address
        print("GET request to: " + endPoint)
        AF.request(endPoint)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Get request successful")
                    let parsedResponse = JSON as! NSDictionary
                    parsedResponse.setValue("endpoint", forKey: response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: ""))
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    self.responseData?.onFailure(error as! NSDictionary)
                }
        }
    }
    
    func delete(_ parameters: [String: String], _ authToken: String, _ address: String){
        let endPoint: String = urlString + address
        print("DELETE request to: " + endPoint)
        AF.request(endPoint,
                   method: .delete,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print()
                switch response.result {
                case .success(let JSON):
                    print("Delete request successful")
                    let parsedResponse = JSON as! NSDictionary
                    parsedResponse.setValue("endpoint", forKey: response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: ""))
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    self.responseData?.onFailure(error as! NSDictionary)
                }
        }
    }
}

