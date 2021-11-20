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
		return Data()
	}
	
	var task: Task {
		return .requestParameters(parameters: ["q": city], encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? = nil
	
	
}

class NetworkApiManager: ApiManagement {
	lazy var provider = MoyaProvider<WeatherService>(plugins: getPlugins())
	
	func getCityWeather(city: String) -> Single<String> {
		
		return provider.rx.request(WeatherService(city: city))
			.map{ _ in "weather response"}
	}
	
	
	private func getPlugins() -> [NetworkLoggerPlugin]{
		let loggerPlugin = NetworkLoggerPlugin(configuration:
			.init(formatter: .init(responseData: JSONResponseDataFormatter)
				, logOptions: .verbose))
		return [loggerPlugin]
	}
	
	private let JSONResponseDataFormatter: (_ data: Data) -> String = { data in
	 do {
		 let dataAsJSON = try JSONSerialization.jsonObject(with: data)
		 let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
		 return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
	 } catch {
		 return String(data: data, encoding: .utf8) ?? ""
	 }
 }
	
}
