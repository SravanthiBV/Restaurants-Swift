//
//  NetworkReachabilityManager.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/25/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

class NetworkReachabilityManager : NSObject{
    
    let reachability = Reachability.forInternetConnection()
    static let sharedInstance :NetworkReachabilityManager = {
        return NetworkReachabilityManager()
        
    }()
    
    override init() {
        super.init()
        reachability!.reachableBlock = {
            (reach:Reachability?) -> Void in
            DispatchQueue.main.async {
                print("REACHABLE!")
            }
        }
        
        reachability!.unreachableBlock = {
            (reach:Reachability?) -> Void in
            print("unREACHABLE!")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        reachability!.startNotifier()
    }
    
    func isNetworkReachable() -> Bool{
        var isReachable = false
        if reachability!.isReachableViaWiFi() || reachability!.isReachableViaWWAN() {
            print("there is internet")
            isReachable = true
        }
        else {
            print("there is no internet")
            isReachable = false
        }
        return isReachable
    }
    
    @objc func reachabilityChanged(notification: NSNotification){
        
    }
}
