//
//  ApiManagement.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import RxSwift

protocol ApiManagement {
	associatedtype WeatherRaw
	func getCityWeather<WeatherRaw:WeatherPresenterFactory & Decodable>(city: String) -> Single<WeatherRaw>
}
