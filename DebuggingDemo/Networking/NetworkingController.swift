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
    
    func composedURL() -> URL {
        switch self {
        case .current(let lat, let lon):
            return URL(string: "api.openweathermap.org/data/2.5/weather?lat=\(lon)&lon=\(lat)&appid=\(apiKey)")!
        }
    }
}

struct NetworkingController {
    
}
