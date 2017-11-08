//
//  TimeInterval+format.swift
//  WeatherGift
//
//  Created by Vlad Chilom on 11/7/17.
//  Copyright © 2017 Vlad Chilom. All rights reserved.
//

import Foundation

extension TimeInterval {
  
  func format(timeZone: String, dateFormatter: DateFormatter) -> String {
    let usableDate = Date(timeIntervalSince1970: self)
    dateFormatter.timeZone = TimeZone(identifier: timeZone)
    let dateString = dateFormatter.string(from: usableDate)
    return dateString
  }
  
}
