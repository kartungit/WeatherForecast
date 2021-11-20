//
//  NetworkApiManager.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import RxSwift
import Moya

struct WeatherService: TargetType {
	let city: String
	
	var baseURL: URL {
		let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?cnt=7&appid=60c6fbeb4b93ac653c492ba806fc346d&units=metric"
		return URL(string: urlString)!
	}
	
	var path: String {
		return ""
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return TestResources.readJSON(name: UserTestData.saigonWeather.rawValue)
	}
	
	var task: Task {
		return .requestParameters(parameters: ["q": city], encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? = nil
	
	
}

class WeatherNetworkApiManager<T: WeatherPresenterFactory & Decodable>: MoyaNetwork<WeatherService>, ApiManagement {
	typealias WeatherRaw = T
	
	func getCityWeather<T>(city: String) -> Single<T> where T : WeatherPresenterFactory, T : Decodable {
		
		return callApi(WeatherService(city: city), dataReturnType: T.self)
	}
}
