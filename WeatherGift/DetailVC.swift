//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Vlad Chilom on 10/31/17.
//  Copyright © 2017 Vlad Chilom. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "EEEE, MMM dd, y"
  return dateFormatter
}()

class DetailVC: UIViewController {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var currentImage: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var currentPage = 0
  var locationsArray = [WeatherLocation]()
  var locationDetail: WeatherDetail!
  var locationManger: CLLocationManager!
  var currentLocation: CLLocation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    collectionView.delegate = self
    collectionView.dataSource = self
    
    locationDetail = WeatherDetail(name: locationsArray[currentPage].name, coordinates: locationsArray[currentPage].coordinates)
    
    if currentPage != 0 {
      self.locationDetail.getWeather {
        self.updateUserInterface()
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if currentPage == 0 {
      getLocation()
    }
  }
  
  func updateUserInterface() {
    locationLabel.text = locationDetail.name
    let dateString = locationDetail.currentTime.format(timeZone: locationDetail.timeZone, dateFormatter: dateFormatter)
    dateLabel.text = dateString
    temperatureLabel.text = locationDetail.currentTemp
    summaryLabel.text = locationDetail.dailySummary
    currentImage.image = UIImage(named: locationDetail.currentIcon)
    tableView.reloadData()
    collectionView.reloadData()
  }
  
}

extension DetailVC: CLLocationManagerDelegate {
  
  func getLocation(){
    locationManger = CLLocationManager()
    locationManger.delegate = self
  }
  
  func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManger.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      locationManger.requestLocation()
    case .denied:
      print("There is no location to show")
    case .restricted:
      print("No Access")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    handleLocationAuthorizationStatus(status: status)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let geoCoder = CLGeocoder()
    var place = ""
    currentLocation = locations.last
    let currentLatitude = currentLocation.coordinate.latitude
    let currentLongitude = currentLocation.coordinate.longitude
    let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
    geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
      if placemarks != nil {
        let placemark = placemarks?.last
        place = (placemark?.name)!
      } else {
        print("Error retrieving place. Error code: \(error!)")
        place = "Unknown Weather Location"
      }
      self.locationsArray[0].name = place
      self.locationsArray[0].coordinates = currentCoordinates
      self.locationDetail = WeatherDetail(name: place, coordinates: currentCoordinates)
      self.locationDetail.getWeather {
        self.updateUserInterface()
      }
    })
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get user location.")
  }
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationDetail.dailyForecastArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
    let dailyForecast = locationDetail.dailyForecastArray[indexPath.row]
    let timeZone = locationDetail.timeZone
    cell.update(with: dailyForecast, timeZone: timeZone)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return locationDetail.hourlyForecastArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCell
    let hourlyForecast = locationDetail.hourlyForecastArray[indexPath.row]
    let timeZone = locationDetail.timeZone
    hourlyCell.update(with: hourlyForecast, timeZone: timeZone)
    return hourlyCell
  }
}
