//
//  WeatherManager.swift
//  Clima
//
//  Created by Danylo Kushlianskyi on 04.08.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    let KEY = "002b8d30b04e0712e108b538a0aab2ac"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=002b8d30b04e0712e108b538a0aab2ac&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String){
        let URLString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: URLString)
    }
    
    func fetchWeather (lattitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let URLString = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)"
        performRequest(with: URLString)
    }
    
    func performRequest(with urlString: String){
        if let URL = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { data, response, error in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherData.self, from: safeData)
                        let id = decodedData.weather[0].id
                        let temp = decodedData.main.temp
                        let cityName = decodedData.name
                        
                        let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
                        self.delegate?.didUpdateWeather(self,weather: weather)
                        
                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    
}

