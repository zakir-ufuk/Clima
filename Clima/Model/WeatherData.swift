//
//  WeatherData.swift
//  Clima
//
//  Created by Zakir Ufuk Sahiner on 20.04.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String // we are writing name of the things we would like to get from the API's JSON file
    let main: Main // because temp is inside the main in JSON file we have to create a new struct for it (see below) and then use it here
    let weather: [Weather] // because Weather property hold arrays 
    
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
