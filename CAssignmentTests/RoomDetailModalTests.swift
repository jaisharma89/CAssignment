//
//  RoomDetailModalTests.swift
//  CAssignmentTests
//
//  Created by Optimum  on 20/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import XCTest
@testable import CAssignment

class RoomDetailModalTests: XCTestCase {
    
    override func setUp() {
    }
    // Desc : it tests the RoomDetailModal Initialization if one of the mandatory value is missing in Response
    // Expected : the value should be nil as we expect Level the vaue in response
    func testInitializationLevelMissing()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalLevelvalueMissing, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        XCTAssertNil(roomDetail)
    }
    // Desc : it tests the RoomDetailModal Initialization if one of the mandatory value is missing in Response
    // Expected : the value should be nil as we expect Capacity the vaue in response
    func testInitializationCapacityMissing()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalCapacityvalueMissing, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        XCTAssertNil(roomDetail)
    }
    // Desc : it tests the RoomDetailModal Initialization if one of the mandatory value is missing in Response
    // Expected : the value should be nil as we expect Name the vaue in response
    func testInitializationNameMissing()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalNamevalueMissing, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        XCTAssertNil(roomDetail)
    }
    // Desc : it tests the RoomDetailModal Initialization if one of the Optional value is missing in Response
    // Expected : the value should be create RoomDetailModal instance as we expect Availablity is optional
    func testInitializationAvailabiltyMissing()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalAvailabiltyvalueMissing, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        XCTAssertNotNil(roomDetail)
        XCTAssertEqual(roomDetail?.level, "7")
    }
    // Desc : it tests the RoomDetailModal Initialization if we provide expected data
    // Expected : the value should be create RoomDetailModal instance
    func testInitializationAllValues()
    {
        guard let record = try? JSONSerialization.jsonObject(with: modalIdeal, options: []) as? [String: Any]
            else { return }
        let roomDetail = RoomDetailModal(roomDetail: record as [String : AnyObject])
        XCTAssertNotNil(roomDetail)
        XCTAssertEqual(roomDetail?.level, "7")
        XCTAssertEqual(roomDetail?.capacity, 8)
    }
    override func tearDown() {
    }
    
    
    
    func testPerformanceExample() {
        self.measure {
            guard let record = try? JSONSerialization.jsonObject(with: modalIdeal, options: []) as? [String: Any]
                       else { return }
            _ = RoomDetailModal(roomDetail: record as [String : AnyObject])
           
        }
    }
    
    private let modalLevelvalueMissing = Data("""
    {
        "name": "Kopi-O",
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
    private let modalNamevalueMissing = Data("""
    {
        "capacity": "8",
         "level": "7",
        "availability": {
            "08:00": "1",
            "08:30": "1",
            "09:00": "0",
            "09:30": "0",
            "10:00": "0",
        }
    }
    """.utf8)
    private let modalCapacityvalueMissing = Data("""
    {
        "name": "Kopi-O",
         "level": "7",
        "availability": {
            "08:00": "1",
            "08:30": "1",
            "09:00": "0",
            "09:30": "0",
            "10:00": "0",
        }
    }
    """.utf8)
    private let modalAvailabiltyvalueMissing = Data("""
    {
         "name": "Kopi-O",
         "level": "7",
         "capacity": "8",
    }
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
    
}

