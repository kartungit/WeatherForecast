//
//  WeatherService.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Moya

struct WeatherService: TargetType, Cachable {
	
	let city: String
	
	var baseURL: URL {
		#if DEBUG
		if let invalidUrl = ProcessInfo.processInfo.environment["baseURL"] {
			print("THINH debug with baseURL \(invalidUrl)")
		}
		#endif
		let urlString = ProcessInfo.processInfo.environment["baseURL"] ?? AppConfig.BASE_API_URL
		return URL(string: urlString)!
	}
	
	var path: String {
		return "data/2.5/forecast/daily"
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return TestResources.readJSON(name: UserTestData.saigonWeather.rawValue)
	}
	
	var task: Task {
		return .requestParameters(parameters: ["q": city,
											   "cnt": 7,
											   "unit": "metric",
											   "appid": AppConfig.OPEN_WEATHER_ID],
								  encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? = nil
	
	var cacheManager: CacheManager = CacheManager(expireTime: .disable)

}

extension Cachable {
	var urlRequest: String {
		let endpoint = Endpoint(url: URL(target: self).absoluteString,
								sampleResponseClosure: {.networkResponse(200, self.sampleData)},
								method: self.method,
								task: self.task,
								httpHeaderFields: self.headers)
		let urlRequest = try? endpoint.urlRequest()
		let urlString = urlRequest?.url?.absoluteString ?? ""
		return urlString
	}
	
	func getCache<T: Decodable>() -> T? {
		cacheManager.get(key: urlRequest)
	}
	
	func storeCache(expirable: Expirable) {
		guard urlRequest.count > 0 else { return }
		
		cacheManager.store(key: urlRequest, value: expirable)
	}
	
}
