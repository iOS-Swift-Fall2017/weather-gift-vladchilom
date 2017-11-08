//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Vlad Chilom on 10/31/17.
//  Copyright © 2017 Vlad Chilom. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
  
  var name: String
  var coordinates: String
  
  init(name: String, coordinates: String) {
    self.name = name
    self.coordinates = coordinates
  }
  
}

