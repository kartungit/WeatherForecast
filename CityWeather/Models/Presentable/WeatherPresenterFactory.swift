//
//  WeatherPresenterFactory.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Foundation

protocol WeatherPresenterFactory {
	func errorViewPresenter() -> WeatherPresentModel
	func weatherPresenter(model: WeatherNetworkModel) -> WeatherPresentModel
}
