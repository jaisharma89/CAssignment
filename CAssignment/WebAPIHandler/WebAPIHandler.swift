//
//  WebAPIHandler.swift
//  CAssignment
//
//  Created by Optimum  on 17/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit


enum Result<T, CustomError> {
    case Success(T)
    case Failure(WebError)
}




class WebAPIHandler: NSObject , URLSessionDelegate {
    
    fileprivate static var Instance: WebAPIHandler?
    var session: URLSession!
    
    var networkStatus : NetworkStatus  {
        let reachability = NetReachability.reachabilityWithHostName(hostName: Constants.linkNetworkCheck)
        return reachability
    }
    class func getInstance() -> WebAPIHandler {
        if Instance == nil {
            Instance = WebAPIHandler()
        }
        return Instance!
    }
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        self.session = URLSession(configuration: configuration, delegate: self , delegateQueue:OperationQueue.main)
    }
    class func deallocInstance() {
        Instance = nil
    }
    func makeRequestWithServer (_  requestUrl : URL , session : URLSession,reqCompletionHandler: @escaping (Result<Data? ,WebError>?) -> Void)
    {
        if !getNetworkStatus()
        {
             reqCompletionHandler(.Failure(.noInternetConnection))
        }
        
        let request = URLRequest(url: requestUrl)
        WebAPIHandler.getDataFromRequest(request , session: session) { (data, error , response) in
            guard let response = response as? HTTPURLResponse else {
                reqCompletionHandler(.Failure(.other))
                return
            }
            if (200..<300) ~= response.statusCode {
                reqCompletionHandler(.Success(data))
            } else if response.statusCode == 401 {
                reqCompletionHandler(.Failure(.unauthorized))
            } else {
                if error != nil
                {
                    reqCompletionHandler(.Failure(.custom(error!)))
                }
                else
                {
                    reqCompletionHandler(.Failure(.other))
                }
            }
        }
    }
    static func getDataFromRequest(_ request: URLRequest!, session: URLSession!, reqCompletionHandler: @escaping (Data?, Error? , URLResponse?) -> Void)
    {
        
        let task = session!.dataTask(with: request) { (data, response, error) in
            reqCompletionHandler(data,error , response)
        }
        task.resume()
    }
    func getNetworkStatus () -> Bool
    {
       return networkStatus == .notReachable ?  false :  true
           
        
    }
}
