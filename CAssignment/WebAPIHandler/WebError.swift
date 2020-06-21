//
//  WebError.swift
//  CAssignment
//
//  Created by Optimum  on 17/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

public enum WebError: Error   {
   
    
    
    case noInternetConnection
    case custom(Error)
    case unauthorized
    case other
}
