//
//  NetworkApiManager.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class WeatherNetworkApiManager: MoyaNetwork<WeatherService>, ApiManagement {
	
	func getCityWeather(city: String) -> Single<WeatherNetworkModel> {
		
		return callApi(WeatherService(city: city),
					   dataReturnType: WeatherNetworkModel.self)
	}
}
