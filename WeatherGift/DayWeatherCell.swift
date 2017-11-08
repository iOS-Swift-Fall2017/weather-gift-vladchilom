//
//  DayWeatherCell.swift
//  WeatherGift
//
//  Created by Vlad Chilom on 10/31/17.
//  Copyright © 2017 Vlad Chilom. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "EEEE"
  return dateFormatter
}()

class DayWeatherCell: UITableViewCell {
  @IBOutlet weak var dayCellIcon: UIImageView!
  @IBOutlet weak var dayCellWeekday: UILabel!
  @IBOutlet weak var dayCellMaxTemp: UILabel!
  @IBOutlet weak var dayCellMinTemp: UILabel!
  @IBOutlet weak var dayCellSummary: UITextView!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func update(with dailyForecast: WeatherDetail.DailyForecast, timeZone: String) {
    dayCellIcon.image = UIImage(named: dailyForecast.dailyIcon)
    dayCellSummary.text = dailyForecast.dailySummary
    dayCellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp) + "°"
    dayCellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp) + "°"
    let dateString = dailyForecast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
    dayCellWeekday.text = dateString
  }
  
}
