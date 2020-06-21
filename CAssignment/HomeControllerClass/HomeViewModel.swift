//
//  HomeViewModel.swift
//  CAssignment
//
//  Created by Optimum  on 19/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

public enum SortOptions : Int {
    case level = 0
    case capacity 
    case availability
}

class HomeViewModel: NSObject {
    
    var records : [RoomDetailModal] = []
    var webHandlerInstance = WebAPIHandler.getInstance()
    //Function get Response from API and update the UI based on Data
    func getRoomRecords (date: String ,time:String,completionHandler: @escaping (Bool, WebError?) -> Void){
        let requestUrl = URL(string: Constants.networkHostURL)!
        
        let selectedTimeSlot = Utility.getSelectedTime(time:date + " " + time)
        
        webHandlerInstance.makeRequestWithServer(requestUrl, session: webHandlerInstance.session) { (result) in
            do {
                switch result
                {
                case .Success(let data):
                    let recordsArr = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    print(recordsArr)
                    for record in recordsArr
                    {
                        if let roomDetail = RoomDetailModal(roomDetail: record as! [String : AnyObject])
                        {
                            roomDetail.isAvailable = self.checkRoomAvailabilityForTime(time: selectedTimeSlot, room: roomDetail)
                            self.records.append(roomDetail)
                        }
                    }
                    if self.records.count > 0
                    {
                        self.records.sort { $0.level < $1.level }
                        completionHandler(true ,nil)
                    }
                    else
                    {
                        completionHandler(false, .other)
                    }
                    
                    break
                case .Failure(let error):
                    completionHandler(false,error)
                    break
                case .none:
                    completionHandler(false, .other)
                }
            }
            catch _ as NSError
            {
                completionHandler(false, .other)
            }
        }
    }
    //Function Check Room availabilty with the given time  ,returns false if no value available for given time
    func checkRoomAvailabilityForTime (time: String ,room:RoomDetailModal) -> Bool
    {
        if room.availability[time] != nil
        {
            let value = room.availability[time] as! NSString
            return value.boolValue
        }
        return false
    }
    //Function Sort Rooms array with given options eg Level , Capacity
    func sortby(type : SortOptions ,handler:  (Bool) -> Void)
    {
        switch type {
        case .level:
            self.records.sort { $0.level < $1.level }
            print("levelSorted")
            break
        case .availability:
            self.records.sort { $0.isAvailable && !$1.isAvailable }
            print("AvailSorted")
            break
        case .capacity:
            self.records.sort { $0.capacity > $1.capacity }
            print("Capacity")
            break
        }
        handler(true)
    }
    
}
