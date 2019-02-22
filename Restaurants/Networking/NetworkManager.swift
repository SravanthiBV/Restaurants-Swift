//
//  NetworkManager.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/21/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit
import Foundation

class NetworkManager: NetworkRequestDelegate {
    func makeRequest(urlString : String, onCompletion: ((_:Data?,_:String) -> ())?){
        
        guard
            let url = URL(string: urlString)
            else {
                onCompletion?(nil,"")
                return
        }
        
        let session = URLSession(configuration: .default)
        let imageFromUrl = session.dataTask(with: url) { (data, response, error) in
            if let responseData = response{
                print(responseData)
            }
            if let errorData = error{
                print(errorData)
            }
//            if let contents = data{
//                print(contents)
//                let image = UIImage(data: contents)
//                print(image)
//            }
            onCompletion?(data,urlString)
        }
        imageFromUrl.resume()
    }
}
