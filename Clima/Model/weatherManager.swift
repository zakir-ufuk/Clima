//
//  weatherManager.swift
//  Clima
//
//  Created by Zakir Ufuk Sahiner on 19.04.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=c0d289bea5f6a212ae3522962b031282&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    // url that we got from API, be sure that it starts with https not http
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)" // creating the URL
        performRequest(with: urlString) // sending the URL to performRequest function below
    }
    // creating the URL with lat and long which we got from our locationservices
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)  {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // ***** Networking *****
    func performRequest(with urlString: String) {
        //1. Create an URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                // first of all we are checking if there was an error! If there is no error we can continue with the data (if there was an error trying to continue would cause more problems)
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }// optional bind in case nil comes
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   

    }
    
