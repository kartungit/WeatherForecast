//
//  WeatherModel.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation

protocol WeatherPresenterFactory {
	var locationToastText: String { get }
	
	func weatherPresenter() -> WeatherPresentModel
}

struct WeatherPresentModel {
	var locationToastText: String
}

extension WeatherNetworkModel: WeatherPresenterFactory {
	var locationToastText: String {
		return "\(city?.name ?? ""), \(city?.country ?? "")"
	}
	
	func weatherPresenter() -> WeatherPresentModel {
		return WeatherPresentModel(locationToastText: locationToastText)
	}
}
