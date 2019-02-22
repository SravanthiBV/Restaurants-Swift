//
//  RestaurantDataSource.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/20/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit


class RestaurantDataSource {
    var restaurantData = [RestaurantItem]()
    var downloadedImageData = [String:Data?]()
    func readJsonData(){
        guard let filePath = Bundle.main.path(forResource: "restaurantDetails", ofType: "json") else{
            print("Could not find restaurant details file")
            return
        }
        print(filePath)
        guard let fileContent = try? Data(contentsOf:URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            else{
                print("Failed to get contents of file")
                return
        }
        print(fileContent)
        if let jsonResult = try? JSONSerialization.jsonObject(with: fileContent, options: .mutableLeaves){
            if let jsonDict = jsonResult as? Dictionary<String,AnyObject>{
                print(jsonDict);
                let jsonArray: [[String:String]] = jsonDict["restaurants"]! as! [[String:String]]
                for data in jsonArray {
                    var name : String? , imagePath :String? , address: String? , pincode: String?
                    if !data.isEmpty{
                        name = data["name"]
                        imagePath = data["image"]
                        address = data["address"]
                        pincode = data["pincode"]
                    }
                    
                    let restaurant = Restaurant(name:name,imagePath:imagePath,address:address,pincode:pincode,imageData:nil)
                    restaurantData.append(restaurant)
                }
            }
            else{
                
            }
        }
        else{
            print("Failed to get contents of file")
        }
    }
    
    func getRestaurants(onCompletion: @escaping (([RestaurantItem]) -> ())){
        
        if !restaurantData.isEmpty{
            
        }
        let networkDelegate : NetworkRequestDelegate = NetworkManager()
        let dispatchGroup = DispatchGroup()
        
        readJsonData()
        
        for ( index,restaurant) in self.restaurantData.enumerated(){
            if let requestPath = restaurant.imagePath {
                
                dispatchGroup.enter()
                print("index request \(index)")
               // let semaphore = DispatchSemaphore(value: 1)
                //semaphore.wait()
                networkDelegate.makeRequest(urlString: requestPath){
                    [weak self] (responseData,request) in
                    print("index before \(index)")
                    self?.downloadedImageData[requestPath] = responseData
                    //self?.downloadedImageData.updateValue(responseData, forKey: request)
                    print("requestPath is \(requestPath) and data \(responseData)")
                    //print("responseData is \(responseData)")
                    print("index after \(index)")
                    dispatchGroup.leave()
                    //semaphore.signal()
                }
            }
        }
        
        
        dispatchGroup.notify(queue: DispatchQueue.global()){
            [weak self] in
            self?.updateImageData()
            //let restaurantArray = self?.restaurantData
            onCompletion(self?.restaurantData ?? [])
            print("completed downloading all the images")
        }
    }
    
    func updateImageData(){
        print(restaurantData.count)
        print(downloadedImageData.count)
        for (index,restaurant) in restaurantData.enumerated(){
            if let imagePath = restaurant.imagePath, let _ = downloadedImageData[imagePath]{
                restaurantData[index].imageData = downloadedImageData[imagePath]!
            }
        }
    }
    
    deinit {
        
    }
}
