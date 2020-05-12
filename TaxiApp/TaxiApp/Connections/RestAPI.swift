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
                switch response.result {
                case .success(let JSON):
                    print("Post request Successful")
                    self.responseData?.onSuccess(JSON as! NSDictionary)
                case let .failure(error):
                    print(error)
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
                    print("Get success")
                    //self.responseData?.onSuccess(JSON as! NSDictionary)
                case let .failure(error):
                    print(error)
                }
        }
    }
}

