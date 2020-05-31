//
//  CustomerTests.swift
//  TaxiAppTests
//
//  Created by Radu Rusu on 31/05/2020.
//  Copyright © 2020 Niels Wilmsen. All rights reserved.
//
import Foundation
import Alamofire
import XCTest
@testable import TaxiApp

class CustomerTests: XCTestCase {
    
    var urlString = "https://taxiapi.eu-gb.mybluemix.net"

    func post(_ parameters: [String: Any], _ address: String){
        let endPoint: String = urlString + address
        print("POST request to: " + endPoint)
        AF.request(endPoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
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
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTheRightUserFromDatabase() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var customer = Customer("String", "String", "String", "String", "String")
        
    }

}

