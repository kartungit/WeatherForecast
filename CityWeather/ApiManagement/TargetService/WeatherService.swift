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
		let urlString = BASE_API_URL + "data/2.5/forecast/daily?cnt=7&appid=60c6fbeb4b93ac653c492ba806fc346d&units=metric"
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
	
	var expireTime: ExpireTime = ExpireTime.disable
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
		guard let expirable = CacheManager.shared.object(forKey: urlRequest as NSString) else { return nil }
		
		guard !hasExpired(time: expirable.time) else {
			return nil
		}
			
		return expirable.value as? T
		
	}
	
	func storeCache(expirable: Expirable) {
		guard urlRequest.count > 0 else { return }
		
		CacheManager.shared.setObject( expirable, forKey: urlRequest as NSString)
	}
	
	func hasExpired(time: Date) -> Bool {
		switch expireTime {
			case .disable:
				return true
			case .inSecond(let second):
				let date = Date()
				return date > time.addingTimeInterval(TimeInterval(second))
		}
	}
}
