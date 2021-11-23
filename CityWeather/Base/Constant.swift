//
//  Constant.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//
import Foundation

final class AppConfig {
	static let BASE_API_URL = AppConfig.infoForKey("Base API URL")
	static let BASE_IMG_SOURCE = AppConfig.infoForKey("Base image URL")
	static let OPEN_WEATHER_ID = AppConfig.infoForKey("OpenWeatherID")
	
	static func infoForKey(_ key: String) -> String {
		return (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "") ?? ""
	}
}

