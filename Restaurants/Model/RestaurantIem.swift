//
//  RestaurantIem.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/22/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

protocol RestaurantItem {
    var name :String? {get}
    var imagePath : String? {get}
    var address : String? {get}
    var pincode : String? {get}
    var imageData : Data? {get set}
}
