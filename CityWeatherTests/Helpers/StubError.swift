//
//  StubError.swift
//  CityWeatherTests
//
//  Created by ThinhMH on 25.11.2021.
//

import Foundation
@testable import CityWeather

extension ApiError {
	static let notFound = ApiError.serverError(response: CodeError.notFound.errorResponse)
	static let noNetwork = ApiError.networkError(code: -1003)
	
	static func mockNoNetwork() -> NSError {
		NSError(domain: "mockError", code: -1003, userInfo: [:])
	}
}

extension ApiError: Equatable {
	public static func == (lhs: ApiError, rhs: ApiError) -> Bool {
		return lhs.description == rhs.description
	}
}
