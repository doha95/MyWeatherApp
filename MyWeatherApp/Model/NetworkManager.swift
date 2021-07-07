//
//  NetworkManager.swift
//  MyWeatherApp
//
//  Created by Doha Tubaileh on 30/6/2021.
//

import Foundation
import Alamofire
import MapKit

protocol NetworkManagerDelegate {
    func didUpdateWeatther(weather:WeatherModel)
    func didFailedWithError(error:Error)
}

struct NetworkManager {
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dec828f130c2db16f6c7b7831bf00daf&units=metric"
    var delegate : NetworkManagerDelegate?
    
    func fetchWeatherFor(wih city: String ) {
        let urlString = "\(weatherURL)&q=\(city)"
        requestData(urlString: urlString) { weather in
            delegate?.didUpdateWeatther(weather: weather)
        }
    }
    
    func fetchWeatherFor(wih longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        requestData(urlString: urlString) { weather in
            delegate?.didUpdateWeatther(weather: weather)
        }
    }
    
    private func requestData(urlString: String, completion: @escaping (_ weather:WeatherModel) -> Void) {
        let request = AF.request(urlString)
        request.validate().responseDecodable(of: WeatherData.self) { (response) in
            switch response.result {
            case .success:
                if let data = response.value {
                    let weatherResponse = WeatherModel(conditionId: data.weather[0].id, city: data.name, temp: data.main.temp)
                    completion(weatherResponse)
                }
            case let .failure(error):
                delegate?.didFailedWithError(error: error)
            }
        }
    }
}
