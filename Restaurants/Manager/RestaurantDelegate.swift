//
//  RestaurantDelegate.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/22/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

protocol RestaurantDelegate{
    func getRestaurantIems(onCompletion:@escaping(([RestaurantItem]) -> ()))
}
