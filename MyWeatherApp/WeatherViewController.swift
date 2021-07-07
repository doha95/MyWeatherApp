//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Doha Tubaileh on 16/6/2021.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextFeild.delegate = self
        networkManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func updateUIWithWeather(weather:WeatherModel) {
        tempretureLabel.text = weather.tempString
        cityLabel.text = weather.city
        weatherImage.image = UIImage(systemName: weather.conditionName)
    }
    
    deinit {
        print("The WeatherViewController Successfully Deinit!")
    }
}
//MARK: - WeatherNetwork delegate
extension WeatherViewController : NetworkManagerDelegate {
   
    func didUpdateWeatther(weather: WeatherModel) {
        updateUIWithWeather(weather: weather)
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - TextInput delegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchDidSelect(_ sender: UIButton) {
        searchTextFeild.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextFeild.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        networkManager.fetchWeatherFor(wih:  searchTextFeild.text!)
        //clear the text feild
        searchTextFeild.text = ""
    }
    
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func findMyLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let longitude = locValue.longitude
        let latitude = locValue.latitude
        locationManager.stopUpdatingLocation()
        networkManager.fetchWeatherFor(wih: longitude, latitude: latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error: \(error.localizedDescription)")
    }
}
