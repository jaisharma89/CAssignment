//
//  UtilityTests.swift
//  CAssignmentTests
//
//  Created by Optimum  on 21/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import XCTest
@testable import CAssignment

class UtilityTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    // Desc : it tests the method ouput for required format with expected values
    // Expected : All minutes value from 1-29 should be 00 and 31-59 should be 30 and change hour format to 24hr format
   func testGetSelectedTimeWithExpectedParams()
   {
    let strAmTime = Utility.getSelectedTime(time: "Jul 3, 2020 02:13 AM")
    let strPmTime = Utility.getSelectedTime(time: "Jul 3, 2020 04:33 PM")
    
    XCTAssertEqual(strAmTime, "02:00")
    XCTAssertEqual(strPmTime, "16:30")
    
    }
    
    // Desc : it tests the method ouput for required format with unexpected values
    // Expected : we pass invalid date format and it should return empty string
    func testGetSelectedTimeWithUnexpectedParams()
    {
      let strAmTime = Utility.getSelectedTime(time: "Jul 3, 2020")
      let strPmTime = Utility.getSelectedTime(time: "")
      
      XCTAssertEqual(strAmTime, "")
      XCTAssertEqual(strPmTime, "")
      
     }
    // Desc : it tests the method ouput for required format with expected values
    // Expected : All minutes value from 1-29 should be 00 and 31-59 should be 30
    func testChangeMinutesFormatwithExpectedParams ()
    {
        let strTime = Utility.changeMinutesFormat(timeArr: ["03","14"])
        let strTime1 = Utility.changeMinutesFormat(timeArr: ["08","34"])
        XCTAssertEqual(strTime, "03:00")
        XCTAssertEqual(strTime1, "08:30")
    }
    // Desc : it tests the method ouput for required format with unexpected values
    // Expected : if we pass number greater than 60 function should return the same number as string and if we pass non numeric number its hould return empty string
    func testChangeMinutesFormatwithUnExpectedParams ()
    {
        let strTime = Utility.changeMinutesFormat(timeArr: ["03","99"])
        let strTime1 = Utility.changeMinutesFormat(timeArr: ["08","wee"])
        XCTAssertEqual(strTime, "03:99")
        XCTAssertEqual(strTime1, "")
    }

}
