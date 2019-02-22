//
//  RestaurantManager.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/22/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

class RestaurantManager: RestaurantDelegate {
    let dataSource : RestaurantDataSource
    
    init(withDataSource dataSource: RestaurantDataSource){
        self.dataSource = dataSource
    }
    
    func getRestaurantIems(onCompletion:@escaping(([RestaurantItem]) -> ())){
        dataSource.getRestaurants(){
             (restaurantData) in
            onCompletion(restaurantData)
        }
    }
}
