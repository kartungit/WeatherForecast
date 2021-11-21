//
//  WeatherService.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Moya

struct WeatherService: TargetType {
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
}
