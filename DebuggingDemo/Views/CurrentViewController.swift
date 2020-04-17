import UIKit
import CoreLocation
import MapKit

class CurrentViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    let locationManager = CLLocationManager()
    var shouldFetchLocation = true
    var currentWeather: CurrentWeather? {
        didSet {
            guard let currentWeather = currentWeather else { return }
            
            DispatchQueue.main.async {
                self.cityLabel.text = currentWeather.cityName
                self.conditionLabel.text = currentWeather.condition
                self.feelsLike.text = "\(currentWeather.feelsLike)"
                self.windSpeed.text = "\(currentWeather.windSpeed)"
                self.fetchIcon(id: currentWeather.iconId)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        determineCurrentLocation()
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchCurrentConditions(forLatitude latitude: Double, longitude: Double) {
        NetworkingController().getCurrentWeather(latitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .failure(_):
                self.shouldFetchLocation = true
            case .success(let weather):
                self.currentWeather = weather
            }
        }
    }
    
    func fetchIcon(id: String) {
        NetworkingController().getConditionIcon(id: id) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension CurrentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard shouldFetchLocation else { return }
        let userLocation: CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
        shouldFetchLocation = false
        
        fetchCurrentConditions(forLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension CurrentViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
