//
//  RoomDetailModal.swift
//  CAssignment
//
//  Created by Optimum  on 19/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

///RoomDetail Modal Class for stroing json response from API
class RoomDetailModal: NSObject  {
       var name : String
       var capacity : Int
       var level : String
    var availability = [String: AnyObject]()
       var isAvailable = false
    required init? (roomDetail : [String : AnyObject])
    {
        guard roomDetail["name"] != nil ,roomDetail["capacity"] != nil , roomDetail["level"] != nil   else {
            return nil
        }
        self.name = roomDetail["name"] as! String
        self.capacity = Int(roomDetail["capacity"] as! String) ?? 0
        self.level = roomDetail["level"] as! String
        
        if roomDetail["availability"] != nil{
             self.availability = roomDetail["availability"] as! [String:AnyObject]
        }
       
        
    }
}


