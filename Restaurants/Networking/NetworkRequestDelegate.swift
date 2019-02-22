//
//  NetworkRequestDelegate.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/21/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

protocol NetworkRequestDelegate {
    func makeRequest(urlString : String, onCompletion: ((Data?,String) -> ())?)
}
