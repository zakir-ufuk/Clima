//
//  weatherManager.swift
//  Clima
//
//  Created by Zakir Ufuk Sahiner on 19.04.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=c0d289bea5f6a212ae3522962b031282&units=metric&q="
    // url that we got from API, be sure that it starts with https not http
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)\(cityName)" // creating the URL
        performRequest(urlString: urlString) // sending the URL to performRequest function below
    }
    
    // ***** Networking *****
    func performRequest(urlString: String) {
        //1. Create an URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                // first of all we are checking if there was an error! If there is no error we can continue with the data (if there was an error trying to continue would cause more problems)
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
        
    }
    
    
}
