//
//  MoyaNetwork.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import Moya
import RxSwift

class MoyaNetwork<T: TargetType> {
	
	var provider: MoyaProvider<T>!
	
	init(isMock: Bool = false) {
		self.provider = MoyaProvider<T>(
			stubClosure: isMock ? MoyaProvider.immediatelyStub : MoyaProvider.neverStub,
			plugins: getPlugins())
	}
	
	let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .secondsSince1970
		return decoder
	}()
	
	func callApi<ReturnedObject: Decodable>(
		_ target: T,
		dataReturnType: ReturnedObject.Type
	) -> Single<ReturnedObject> {
		return provider.rx.request(target)
			.filterSuccesfullStatusCode()
			.map(ReturnedObject.self, using: decoder)
			.observeOn(MainScheduler.instance)
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

extension PrimitiveSequence where Trait == SingleTrait, Element: Moya.Response {
	func filterSuccesfullStatusCode() -> Single<Element> {
		return self.catchError{ _ in return .error(APIError.unknown)}
			.flatMap({ response in
			let validator = ApiErrorManagement()
			let reponseStatus = validator.checkResponse(response)
			switch reponseStatus {
				case .success: return .just(response)
				default: return .error(reponseStatus)
			}
		})
	}
}
