//
//  HomeViewModalTests.swift
//  CAssignmentTests
//
//  Created by Optimum  on 19/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import XCTest
@testable import CAssignment

class HomeViewModalTests: XCTestCase {
    
    var viewModal : HomeViewModel!
    
    var session : MockURLSession!
    
    override func setUp() {
        viewModal = HomeViewModel()
        session = MockURLSession()
        viewModal.webHandlerInstance = MockWebHandler()
        viewModal.webHandlerInstance.session = session
    }
    
    override func tearDown() {
        viewModal = nil
        session = nil
    }
    // Desc : it tests the parsing and storing the values functionality in modal with expected response
    // Expected : Records arr should should have 2 objects as we passed in the mocked json response
    func testGetRecordswithExpectedResponse()
    {
        session.data = mockExpectedData
        session.response = HTTPURLResponse(url: URL(string: Constants.networkHostURL)!, statusCode: 200,
                                           httpVersion: nil, headerFields: nil)!
        viewModal.webHandlerInstance.session = session
        
        viewModal.getRoomRecords(date: "", time: "") { (success, webError) in
            XCTAssertEqual(success, true)
            XCTAssertNil(webError)
            XCTAssertEqual(self.viewModal.records.count, 2)
        }
        
        
    }
    // Desc : it tests the parsing and storing the values functionality in modal with unexpected response
    // Expected : Records arr should should have 0 objects as we have provided empty json
    func testGetRecordswithUnExpectedResponse()
    {
        
        session.data = mockUnExpectedData
        session.response = HTTPURLResponse(url: URL(string: Constants.networkHostURL)!, statusCode: 200,
                                           httpVersion: nil, headerFields: nil)!
        
        
        viewModal.getRoomRecords(date: "", time: "") { (success, webError) in
            XCTAssertEqual(success, false)
            if webError != nil
            {
                switch webError {
                case .custom(_):
                    XCTAssert(false)
                    break
                case .other:
                    XCTAssert(true)
                    break
                case .noInternetConnection:
                    XCTAssert(false)
                    break
                default:
                    XCTAssert(false)
                }
            }
            XCTAssertNotNil(webError)
            XCTAssertEqual(self.viewModal.records.count, 0)
        }
        
        
    }
    // Desc : it tests the erro handling
    // Expected : Records should be zero and it should have weberror
    func testGetRecordswithErrorResponse()
    {
        
        session.response = HTTPURLResponse(url: URL(string: Constants.networkHostURL)!, statusCode: 404,
                                           httpVersion: nil, headerFields: nil)!
        session.error = .other
        viewModal.getRoomRecords(date: "", time: "") { (success, webError) in
            XCTAssertEqual(success, false)
            XCTAssertNotNil(webError)
            XCTAssertEqual(self.viewModal.records.count, 0)
        }
    }
    // Desc : it tests the erro handling
    // Expected : Records should be zero and it should have server error
    func testGetRecordswithServerErrorResponse()
    {
        session.response = HTTPURLResponse(url: URL(string: Constants.networkHostURL)!, statusCode: 503,
                                           httpVersion: nil, headerFields: nil)!
        session.error = .other
        
        viewModal.getRoomRecords(date: "", time: "") { (success, webError) in
            XCTAssertEqual(success, false)
            XCTAssertNotNil(webError)
            XCTAssertEqual(self.viewModal.records.count, 0)
        }
    }
    // Desc : It tests the Room availabilty with the user selected time slot
    // Expected : First timeslot should be available and second should be false same as mocked json response
    func testcheckRoomAvailabilityForTimeExpectedValue()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalIdeal, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        let available = viewModal.checkRoomAvailabilityForTime(time: "08:30", room: roomDetail!)
        let notAvailable = viewModal.checkRoomAvailabilityForTime(time: "02:30", room: roomDetail!)
        
        XCTAssertEqual(available, true)
        XCTAssertEqual(notAvailable, false)
    }
}
var mockExpectedData = Data("""
[{
     "name": "Kopi-O",
     "level": "7",
     "capacity": "8",
},{
     "name": "Kopi-O",
     "level": "7",
     "capacity": "8",
}
]
""".utf8)
var mockUnExpectedData = Data("""
[
]
""".utf8)
private let modalIdeal = Data("""
      {
          "name": "Kopi-O",
           "level": "7",
           "capacity": "8",
          "availability": {
              "08:00": "1",
              "08:30": "1",
              "09:00": "0",
              "09:30": "0",
              "10:00": "0",
          }
      }
      """.utf8)
// MARK: Mocking URLSession and URLSessionDataTask
class MockURLSession: URLSession {
    var cachedUrl: URL?
    var data : Data?
    var response : HTTPURLResponse!
    var error :WebError?
    override init ()
    {
        
    }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return MockURLSessionDataTask {
            completionHandler(self.data,self.response ,self.error)
        }
            
    }
    
}
class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
class MockWebHandler : WebAPIHandler
{
  override func getNetworkStatus () -> Bool
    {
        return true
    }
}
