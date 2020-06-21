//
//  WebAPIHandlerTests.swift
//  CAssignmentTests
//
//  Created by Optimum  on 21/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import XCTest
@testable import CAssignment

class WebAPIHandlerTests: XCTestCase {
    
    let webHandler  = WebAPIHandler.getInstance()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        webHandler.session = URLSession(configuration: configuration, delegate: webHandler , delegateQueue:OperationQueue.main)
    }
    
    override func tearDown() {
        
    }
    // Desc : it tests the Service methods with expected value
    // Expected : the Rcords Array should have 15 objects as we have static json response
    func testMakeRequestWithServerWithCorrectURL()
    {
        
        let strHostAddress = Constants.networkHostURL
        let requestUrl = URL(string: strHostAddress)
        var records = [RoomDetailModal]()
        
        let expectation = self.expectation(description: "ResultAPI")
        
        webHandler.makeRequestWithServer(requestUrl!, session: webHandler.session) { (result) in
            
            switch result
            {
                
            case.Success(let data) :
                
                do {
                    let recordsArr = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for record in recordsArr
                    {
                        if let roomDetail = RoomDetailModal(roomDetail: record as! [String : AnyObject])
                        {
                            
                            records.append(roomDetail)
                        }
                    }
                }
                catch _
                {
                    
                }
                expectation.fulfill()
                break
            case .Failure(let error) :
                if self.webHandler.networkStatus == .notReachable
                {
                    switch error {
                    case .noInternetConnection:
                        XCTAssert(true)
                        break
                    default:
                        XCTAssert(false)
                    }
                    expectation.fulfill()
                }
                break
            case .none:
                print("")
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            
            if self.webHandler.networkStatus == .notReachable
            {
                XCTAssert(true)
            }
            else
            {
                XCTAssertEqual(records.count, 15)
                XCTAssertNil(error)
            }
        }
        
        
    }
    // Desc : it tests the Service methods with wrong value
    // Expected : the Rcords Array should have 0 objects as there will be no response from url
    func testMakeRequestWithServerWithWrongURL()
    {
        
        let strHostAddress = "https://gist.githubusercontent.com/yuhong90/room-availability.json"
        let requestUrl = URL(string: strHostAddress)
        var records = [RoomDetailModal]()
        var webAPIError : WebError?
        let expectation = self.expectation(description: "ResultAPI")
        
        webHandler.makeRequestWithServer(requestUrl!, session: webHandler.session) { (result) in
            
            switch result
            {
                
            case.Success(let data) :
                
                do {
                    let recordsArr = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for record in recordsArr
                    {
                        if let roomDetail = RoomDetailModal(roomDetail: record as! [String : AnyObject])
                        {
                            
                            records.append(roomDetail)
                        }
                    }
                }
                catch _
                {
                    
                }
                expectation.fulfill()
                break
            case .Failure( let error) :
                
                webAPIError = error
                expectation.fulfill()
                break
            case .none:
                print("")
            }
        }
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertEqual(records.count, 0)
            
            if self.webHandler.networkStatus == .notReachable
            {
                switch webAPIError {
                case .noInternetConnection:
                    XCTAssert(true)
                    break
                default:
                    XCTAssert(false)
                }
                
                XCTAssertNotNil(webAPIError)
            }
            
            
        }
        
    }
}
