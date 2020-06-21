//
//  Utility.swift
//  CAssignment
//
//  Created by Optimum  on 20/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    /// Function  takes Date and Time  as String
    /// Returns the time in 00 and 30 minutes format
    static  func  getSelectedTime (time: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
       if  let date = dateFormatter.date(from: time)
       {
        dateFormatter.dateFormat = "HH:mm"
        let time24Format = dateFormatter.string(from: date)
        return changeMinutesFormat(timeArr: time24Format.components(separatedBy: ":"))
        
        }
        return ""
    }
    
    static  func changeMinutesFormat( timeArr:[String]) -> String
    {
        if timeArr.count > 1
        {
            var minStr = timeArr[1]
            guard let minValue = Int(minStr) else {
                return ""
            }
            
            switch minValue {
            case 1...29:
                minStr = "00"
                break
            case 31...59:
                minStr = "30"
                break
            default:
                print(minStr)
            }
            return timeArr[0] + ":" + minStr
        }
        return ""
    }
    
}
