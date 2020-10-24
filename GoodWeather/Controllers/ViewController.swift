//
//  ViewController.swift
//  GoodWeather
//
//  Created by Nurtugan Nuraly on 10/15/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet private weak var cityNameTextField: UITextField!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { value in
                guard let city = value else { return }
                guard !city.isEmpty else {
                    self.displayWeather(nil)
                    return
                }
                self.fetchWeather(by: city)
            }).disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        guard let weather = weather else {
            temperatureLabel.text = "🙈"
            humidityLabel.text = "∅"
            return
        }
        temperatureLabel.text = "\(weather.temp - 273.15) °C"
        humidityLabel.text = "\(weather.humidity) 💦"
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL.urlForWeatherAPI(city: cityEncoded) else {
                return
        }
        let resource = Resource<WeatherResult>(url: url)
        /*
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        */
        let search = URLRequest.load(resource: resource)
            .retry(3)
            .observeOn(MainScheduler.instance)
            .catchError { error in
                print(error)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℉"}
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        search.map { "\($0.main.humidity) 💦" }
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

