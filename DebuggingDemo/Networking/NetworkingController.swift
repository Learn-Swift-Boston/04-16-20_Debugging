//
//  File.swift
//  DebuggingDemo
//
//  Created by Matthew Dias on 4/11/20.
//  Copyright © 2020 Matthew Dias. All rights reserved.
//

import Foundation

enum Endpoint {
    case current(lat: Double, lon: Double)
    case icon(id: String)
    
    func composedURL() -> URL {
        switch self {
        case .current(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lon)&lon=\(lat)&appid=\(apiKey)&units=imperial")!
        case .icon(let id):
            return URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
        }
    }
}

struct NetworkingError: Error {}

struct NetworkingController {
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        
        let request = URLRequest.init(url: Endpoint.current(lat: latitude, lon: longitude).composedURL())
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSON else {
                completion(.failure(NetworkingError()))
                return
            }
            
            guard let currentWeather = CurrentWeather(from: json) else {
                completion(.failure(NetworkingError()))
                return
            }
            
            completion(.success(currentWeather))
            
        }.resume()
    }
}
