import Foundation

class RestAPI {
    
    var responseData: Data?
    var urlString = "https://taxi-app.eu-gb.cf.appdomain.cloud"
    
    func post(_ parameters: [String : Any], _ endPoint: String){
        print("POST request to: " + urlString + endPoint)
        //create the url with URL
        let url = URL(string: urlString + endPoint)!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                    self.responseData?.parseResponse(json)
                } else {
                    print("No bueno")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func get(_ endPoint: String){
        
        let myUrl = NSURL(string: urlString + endPoint)!
        URLSession.shared.dataTask(with: myUrl as URL) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:String]] {
                        self.responseData?.parseResponse(json)
                    } else {
                        print("JSON is not an array of dictionaries")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
        
    }
    
}
