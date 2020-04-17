import UIKit

enum Endpoint {
    case current(lat: Double, lon: Double)
    case icon(id: String)
    case fiveDay(zipcode: String)
    
    func composedURL() -> URL {
        switch self {
        case .current(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
        case .icon(let id):
            return URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
        case .fiveDay(let zipcode):
            return URL(string: "https://api.openweathermap.org/data/2.5/forecast?zip=\(zipcode),us&appid=\(apiKey)")!
        }
    }
}

struct NetworkingError: Error {}

struct NetworkingController {
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        
        let request = URLRequest(url: Endpoint.current(lat: latitude, lon: longitude).composedURL())
        
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
    
    func getConditionIcon(id: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let request = URLRequest(url: Endpoint.icon(id: id).composedURL())
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NetworkingError()))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
    
    func getFiveDay(for zipcode: String, completion: @escaping (Result<[DayWeather], Error>) -> Void) {
        let request = URLRequest(url: Endpoint.fiveDay(zipcode: zipcode).composedURL())
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSON else {
                completion(.failure(NetworkingError()))
                return
            }
            
            guard let city = json["city"] as? JSON, let cityName = city["name"] as? String, let list = json["list"] as? [JSON] else {
                completion(.failure(NetworkingError()))
                return
            }
            
            var result = [DayWeather]()
            for (index, dayJson) in list.enumerated() {
                guard index == 0 || index % 8 == 0 else { continue }
                guard let currentCondition = CurrentWeather(from: dayJson, cityName: cityName) else { continue }
                guard let dateString = dayJson["dt_txt"] as? String, let day = dateString.split(separator: " ").first else { continue }
                
                result.append(DayWeather(date: String(day), condition: currentCondition))
            }

            completion(.success(result))
            
        }.resume()
    }
}
