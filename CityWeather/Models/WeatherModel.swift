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
	let dayList: [DayWeatherModel]
	
	static func errorView() -> Self {
		self.init(locationToastText: "", dayList: [])
	}
}

struct DayWeatherModel {
	let date: String
	let aveTemp: String
	let pressure: String
	let humidity: String
	let description: String
	let imgUrl: String
}

extension WeatherNetworkModel: WeatherPresenterFactory {
	var locationToastText: String {
		return "\(city?.name ?? ""), \(city?.country ?? "")"
	}
	
	func weatherPresenter() -> WeatherPresentModel {
		let dayList: [DayWeatherModel] = (self.list?.map{convert(list: $0)})!
		return WeatherPresentModel(locationToastText: locationToastText, dayList: dayList)
	}
	
	private func convert(list: List) -> DayWeatherModel {
		let date = "Date: \(String(describing: list.dt))"
		let aveTemp = ((list.temp?.max ?? 0) + (list.temp?.min ?? 0)) / 2
		let aveTempText = "Average Temperature: \(String(describing: aveTemp))°C"
		let pressure = "Pressure: \(String(describing: list.pressure))"
		let humidity = "Humidity: \(String(describing: list.humidity))%"
		let description = "Description: \(String(describing: list.weather?.description))"
		return DayWeatherModel(date: date,
							   aveTemp: aveTempText,
							   pressure: pressure,
							   humidity: humidity,
							   description: description,
							   imgUrl: "a")
	}
}
