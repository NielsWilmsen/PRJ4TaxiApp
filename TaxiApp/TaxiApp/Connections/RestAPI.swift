import Foundation
import Alamofire

class RestAPI {
    
    var responseData: ResponseHandler?
    var urlString = "https://taxi-app-backend2.eu-gb.mybluemix.net"
    
    func post(_ parameters: [String: String], _ address: String){
        let endPoint: String = urlString + address
        print("POST request to: " + endPoint)
        AF.request(endPoint,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Post request successful")
                    var parsedResponse = JSON as! Dictionary<String, Any>
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    print(error)
                }
        }
    }
    
    func get(_ authToken: String, _ address: String){
        let endPoint: String = urlString + address
        print("GET request to: " + endPoint)
        let parameters = ["Authorization": "Bearer " + authToken] as HTTPHeaders
        AF.request(endPoint,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Get request successful")
                    var parsedResponse = JSON as! Dictionary<String, Any>
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    debugPrint(error)
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
                switch response.result {
                case .success(let JSON):
                    print("Delete request successful")
                    var parsedResponse = JSON as! Dictionary<String, Any>
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    print(error)
                }
        }
    }
}

