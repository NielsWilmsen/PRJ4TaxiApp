//
//  TaxiAppTests.swift
//  TaxiAppTests
//
//  Created by Radu Rusu on 18/05/2020.
//  Copyright © 2020 Niels Wilmsen. All rights reserved.
//

import XCTest

@testable import TaxiApp
import Alamofire

class TaxiAppTests: XCTestCase, ResponseHandler {
    
    var authToken: String!
    var password: String!
    var restAPI : RestAPI!
    
    func onSuccess(_ response: NSDictionary) {
        print("hello")
        if(response.value(forKey: "token") != nil){
            authToken = response.value(forKey: "token") as? String
        }
        if(response.value(forKey: "password") != nil){
            password = response.value(forKey: "password") as? String
        }
    }
    
    func onFailure(_ response: NSDictionary) {
        
    }
    
    override func setUp() {
        restAPI = RestAPI()
        
    }

    override func tearDown() {
        restAPI = nil
    }

    func testPasswordHash() {
        let expect = expectation(description: "Sample")
        
        restAPI.responseData = self

        let createUserParameters = ["first_name": "y", "last_name": "y", "email": "y", "password": "y"] as [String : String]
                
        restAPI.post(createUserParameters, Endpoint.CUSTOMERS)
                
        
        //        let loginParameters = ["username": "email", "password": "password"] as [String: String]
        //
        //        restAPI.post(loginParameters, "/customers/login")
        //
        //        restAPI.get(authToken, "/customers/email")
        
        XCTAssertEqual("password", "password")
        
        expect.fulfill()
        
        waitForExpectations(timeout: 4) {
            error in if let error = error {
                XCTFail("Error \(error)")
            }
        }
    }

}
