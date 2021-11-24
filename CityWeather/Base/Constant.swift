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

struct AccessibilityID {
	
	struct Common {
		struct Toast {
			static let view = "vwToast"
			static let label = "lbToast"
			static let indicator = "vwIndicator"
		}
	}
	
	struct ListWeather {
		static let navigationBar = "navigationBar"
		static let searchTextField = "tfSearch"
		static let dismissSearchView = "vwDismiss"
		static let tableView = "tableView"
		static let emptyListCell = "vwEmpty"
		static let weatherCell = "vwWeatherCell"
	}
}
