import Foundation
import Alamofire
import UIKit

class RestAPI {
    
    var responseData: ResponseHandler?
    var urlString = "https://taxiapi.eu-gb.mybluemix.net"

    func post(_ parameters: [String: Any], _ address: String){
        let endPoint: String = urlString + address
        print("POST request to: " + endPoint)
        AF.request(endPoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Post request successful")
                    var parsedResponse = JSON as! Dictionary<String, Any>
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    debugPrint(error)
                    self.responseData?.onFailure()
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
                    
                    var parsedResponse: Dictionary<String, Any> = [:]
                    var count: Int = 0
                    if let array = JSON as? NSArray {
                        for item in array {
                            parsedResponse["\(count)"] = item as! Dictionary<String, Any>
                            count += 1
                        }
                    } else {
                        parsedResponse = JSON as! Dictionary<String, Any>
                    }
                    
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    debugPrint(error)
                    self.responseData?.onFailure()
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
                    debugPrint(error)
                    self.responseData?.onFailure()
                }
        }
    }
    
    func patch(_ authToken: String, _ address: String) {
        let endPoint: String = urlString + address
        print("PATCH request to: " + endPoint)
        let parameters = ["Authorization": "Bearer " + authToken] as HTTPHeaders
        AF.request(endPoint,
                   method: .patch,
                   headers: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Patch request successful")
                    let NULL = JSON as! NSNull
                    var parsedResponse: Dictionary<String, Any> = [:]
                    parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                    parsedResponse["value"] = NULL
                    self.responseData?.onSuccess(parsedResponse)
                case let .failure(error):
                    debugPrint(error)
                    self.responseData?.onFailure()
                }
        }
    }

    func upload(_ imageData: Data, _ address: String, _ profilePicture: String){
        let endPoint: String = urlString + address
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: profilePicture, fileName: profilePicture, mimeType: "image/jpg")
        },  to: endPoint, usingThreshold: UInt64.init(), method: .post)
        .responseJSON{ response in
                    switch response.result {
                    case .success(let JSON):
                        print("Upload request successful")
                        var parsedResponse = JSON as! Dictionary<String, Any>
                        parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                        self.responseData?.onSuccess(parsedResponse)
                    case let .failure(error):
                        print(error)
                    }
        }
    }
//    
//    func download(_ address: String, _ picture: String){
//        let endPoint: String = urlString + address + picture
//        AF.download(endPoint).responseData { response in
//            if let data = response.value {
//                let image = UIImage(data: data)!
//                var arrayDictionary: Dictionary<String, Any> = [:]
//                arrayDictionary["image"] = image
//                self.responseData?.onSuccess(arrayDictionary)
//            }
//        }
//    }
    
}

