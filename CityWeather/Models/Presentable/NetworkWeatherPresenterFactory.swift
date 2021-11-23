//
//  NetworkWeatherPresenterFactory.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Foundation

class NetworkWeatherPresenterFactory: WeatherPresenterFactory {
	func errorViewPresenter() -> WeatherPresentModel {
		return WeatherPresentModel.errorView()
	}
		
	func weatherPresenter(model: WeatherNetworkModel) -> WeatherPresentModel {
		let locationToastText = "\(model.city?.name ?? ""), \(model.city?.country ?? "")"
		
		guard let list = model.list else {
			return WeatherPresentModel(
					locationToastText: locationToastText,
					dayList: [])
		}
		let dayList: [DayWeatherModel] = list.map{convert(list: $0)}
		return WeatherPresentModel(locationToastText: locationToastText, dayList: dayList)
	}
	
	
	private func convert(list: List) -> DayWeatherModel {
		let date = getDateFromTimeStamp(timeStamp: list.dt)
		let aveTempText = aveTemp(minTemp: list.temp?.min, maxTemp: list.temp?.max)
		let pressure = "Pressure: \(String(describing: list.pressure ?? 0))"
		let humidity = "Humidity: \(String(describing: list.humidity ?? 0))%"
		let weatherDescription = list.weather?.first?.weatherDescription ?? ""
		let description = "Description: \(String(describing: weatherDescription))"
		let imgUrl = "\(AppConfig.BASE_IMG_SOURCE)\(list.weather?.first?.icon ?? "")@2x.png"
		let imageAccessibilityLable = weatherDescription
		return DayWeatherModel(date: date,
							   aveTemp: aveTempText,
							   pressure: pressure,
							   humidity: humidity,
							   description: description,
							   imgUrl: imgUrl,
							   imageAccessibilityLable: imageAccessibilityLable)
	}
	
	private func getDateFromTimeStamp(timeStamp : Int?) -> String {
		guard let timeStamp = timeStamp else { return "N/A" }
		let date = NSDate(timeIntervalSince1970: Double(timeStamp))
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE, dd MMM YYYY"
		let dateString = formatter.string(from: date as Date)
		return "Date: \(dateString)"
	}
	
	private func aveTemp(minTemp: Double?, maxTemp: Double?) -> String {
		guard let minTemp = minTemp,
			  let maxTemp = maxTemp else { return "N/A" }
		let aveTemp = ((minTemp + maxTemp) / 2).rounded(.toNearestOrEven)
		let aveTempText = "Average Temperature: \(String(describing: Int(aveTemp)))°C"

		return aveTempText
	}
}
