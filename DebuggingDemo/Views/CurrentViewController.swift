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
    
}

extension CurrentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard shouldFetchLocation else { return }
        let userLocation: CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
        shouldFetchLocation = false
        
        NetworkingController().getCurrentWeather(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { (result) in
            switch result {
            case .failure(_):
                self.shouldFetchLocation = true
            case .success(let weather):
                DispatchQueue.main.async {
                    self.cityLabel.text = weather.cityName
                    self.conditionLabel.text = weather.condition
                    self.feelsLike.text = "\(weather.feelsLike)"
                    self.windSpeed.text = "\(weather.windSpeed)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension CurrentViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
