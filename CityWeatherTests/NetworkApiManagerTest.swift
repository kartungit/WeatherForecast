//
//  NetworkApiManagerTest.swift
//  CityWeatherTests
//
//  Created by ThinhMH on 20.11.2021.
//

import XCTest
import RxCocoa
import RxSwift
import Moya
import RxBlocking
import RxTest

@testable import CityWeather

class NetworkApiManagerTest: XCTestCase {
	var scheduler: TestScheduler!

	func testMockNetworkSucess() {
		let sut = WeatherNetworkApiManager<WeatherNetworkModel>(isMock: true)
		
		let weather = sut.getCityWeather(city: "stubFile") as Single<WeatherNetworkModel>
		let block = weather.toBlocking()
		
		XCTAssertEqual(try block.toArray().count, 1)
		XCTAssertEqual(try block.first()!.locationToastText, "Ho Chi Minh City, VN")
	}
	
	func testMockNetwork_apiNotFound_emmitErrorNotFound() {
		let sut = StubMoyaNetwork(isMock: true)
		var thrownError: Error?
		
		let weather = sut.requestWithErrorResponse(error: .notFound)
		let block = weather.toBlocking()

		let expectedError = APIError.notFound

		XCTAssertThrowsError(try block.first()) {
					thrownError = $0
				}
		XCTAssertEqual(expectedError,
					   thrownError as? APIError)
	}
}


class StubMoyaNetwork: MoyaNetwork<stubService> {
	
	func successRequest() -> Single<String> {
		callApi(.success, dataReturnType: String.self)
	}
	
	func requestWithErrorResponse(error: APIError) -> Single<Data> {
		let customEndpointClosure = { (target: stubService) -> Endpoint in
			return Endpoint(url: URL(target: target).absoluteString,
							sampleResponseClosure: { .networkResponse(error.rawValue, Data()) },
							method: target.method,
							task: target.task,
							httpHeaderFields: target.headers)
		}

		self.provider = MoyaProvider<stubService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
		
		return callApi(.failed(error), dataReturnType: Data.self)
	}
}


enum stubService: TargetType {
	var baseURL: URL {
		return URL(string: "https://api.openweathermap.org/data/2.5/forecast/")!
	}
	
	var path: String{
		return ""
	}
	
	
	case success
	case failed(APIError)
	
	var sampleData: Data {
		do {
			let dataAsJSON = try JSONEncoder().encode("success")
			return dataAsJSON
		}
		catch {
			return Data()
		}
	}
	
	var method: Moya.Method {
		return .post
	}
	
	var headers: [String : String]? {
		return [:]
	}
	
	var task: Task {
		return .requestPlain
	}
}
