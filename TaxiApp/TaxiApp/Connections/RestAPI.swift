import Foundation
import Alamofire
import SwiftyJSON

class RestAPI {
    
    var responseData: ResponseHandler?
    var urlString = "https://taxiapi.eu-gb.mybluemix.net"

    
    
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

    func upload(image: Data, to url: Alamofire.URLRequestConvertible, params: [String: Any]) {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, with: url)
            .responseJSON{ response in
            switch response.result {
            case .success(let JSON):
                print("Uplaod request successful")
                var parsedResponse = JSON as! Dictionary<String, Any>
                parsedResponse["endpoint"] = response.request!.debugDescription.replacingOccurrences(of: self.urlString, with: "")
                self.responseData?.onSuccess(parsedResponse)
            case let .failure(error):
                print(error)
            }
     }
    }
    
//    func upload(image : Data, params: [String: Any]) {
//        let urlUploadString = "https://taxiapi.eu-gb.mybluemix.net/files"
//        let headers: HTTPHeaders =
//            ["Content-type": "multipart/form-data",
//            "Accept": "application/json"]
//        AF.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in params {
//                    if let temp = value as? String {
//            multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
//
//                    if value is Int {
//        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)}
//
//        if let temp = value as? NSArray {
//            temp.forEach({ element in
//                let keyObj = key + "[]"
//                if let string = element as? String {
//                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
//                } else
//                    if element is Int {
//                        let value = "(num)"
//                        multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
//                }
//            })
//        }
//    }
//                multipartFormData.append(image, withName: "registerImage", fileName: "registerImage.jpg", mimeType: "image/jpeg")
//        },
//            to: urlUploadString, //URL Here
//            method: .post,
//            headers: headers)
//    }
}

