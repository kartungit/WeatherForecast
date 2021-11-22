//
//  WeatherPresentModel.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Foundation

struct WeatherPresentModel {
	var locationToastText: String
	let dayList: [DayWeatherModel]
	
	static func errorView() -> Self {
		self.init(locationToastText: "", dayList: [])
	}
}

struct DayWeatherModel: Equatable {
	let date: String
	let aveTemp: String
	let pressure: String
	let humidity: String
	let description: String
	let imgUrl: String
	let imageAccessibilityLable: String
}
