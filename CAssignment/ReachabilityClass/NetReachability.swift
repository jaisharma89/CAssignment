//
//  NetReachability.swift
//  WeatherSPApp
//
//  Created by Optimum  on 12/9/19.
//  Copyright © 2019 Optimum . All rights reserved.
//

import Foundation
import SystemConfiguration
public let FFReachabilityChangedNotification = "FFNetworkReachabilityChangedNotification"

public enum NetworkStatus
{
    case notReachable, reachableViaWiFi, reachableViaWWAN
    
    public var description : String
    {
        switch self {
        case .reachableViaWWAN:
            return "2G/3G/4G"
        case .reachableViaWiFi:
            return "WiFi"
        case .notReachable:
            return "No Connection"
        }
    }
}

public protocol NetReachabilityProtocol
{
    static func reachabilityWithHostName(hostName : String) -> NetworkStatus
    func startNotifier()
    func stopNotifier()
    var currentReachabilityStatus: NetworkStatus {get}
}

private func & (lhs : SCNetworkReachabilityFlags , rhs : SCNetworkReachabilityFlags) -> UInt32
{
    return lhs.rawValue & rhs.rawValue
}

public class NetReachability : NetReachabilityProtocol
{
    public static func reachabilityWithHostName(hostName: String) -> NetworkStatus {
        let reach = NetReachability(hostname: hostName)
        
        return reach.currentReachabilityStatus
    }
    private var reachability : SCNetworkReachability?
    public init(hostname : String)
    {
        reachability = SCNetworkReachabilityCreateWithName(nil, hostname)!
    }
    
    public func startNotifier() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        SCNetworkReachabilitySetCallback(reachability! , {(_,_,_) in
            NotificationCenter.default.post(name: NSNotification.Name.init(FFReachabilityChangedNotification), object: nil)
            
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetMain(), CFRunLoopMode.commonModes as! CFString )
    }
    
    public func stopNotifier() {
        if reachability != nil
        {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability!, CFRunLoopGetMain(), CFRunLoopMode.commonModes as! CFString)
        }
    }
    
    public var currentReachabilityStatus: NetworkStatus
    {
        if reachability == nil
        {
            return NetworkStatus.notReachable
        }
        
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        SCNetworkReachabilityGetFlags(reachability! , &flags)
        return networkStatus(flags: flags)
    }
    
    func networkStatus(flags : SCNetworkReachabilityFlags) -> NetworkStatus
    {
        if (flags & SCNetworkReachabilityFlags.reachable == 0)
        {
            return .notReachable
        }
        var returnValue = NetworkStatus.notReachable
        if flags & SCNetworkReachabilityFlags.connectionRequired == 0
        {
            returnValue = .reachableViaWiFi
        }
        if flags & SCNetworkReachabilityFlags.connectionOnDemand != 0 || flags & SCNetworkReachabilityFlags.connectionOnTraffic != 0
        {
            if flags & SCNetworkReachabilityFlags.interventionRequired == 0 {
                returnValue = .reachableViaWiFi
            }
        }
        if flags & SCNetworkReachabilityFlags.isWWAN == SCNetworkReachabilityFlags.isWWAN.rawValue
        {
            returnValue = .reachableViaWWAN
        }
        return returnValue
    }
}

