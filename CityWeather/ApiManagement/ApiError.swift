//
//  ApiError.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import Moya

enum APIError: Int, Error{
	case unknown = -1
	case success = 200
	case badRequest = 400
	case expiredToken = 401
	case forbidden = 403
	case notFound = 404
	case serverError = 500
	case serviceUnavailable = 503
	
	var localizedMessage: String {
		switch self {
			case .notFound:
			return "city not found"
			case .serverError:
			return "WebApi internal error. Please contact with administrator"
			case .serviceUnavailable:
			return "No server is available to handle this request."
			default:
			return "Request error"
		}
	}
}

class ApiErrorManagement {
	func checkResponse(_ response: Response) -> APIError {
		switch response.statusCode {
			case 1...200 : return .success
			case 400: return .badRequest
			case 401: return .expiredToken
			case 403: return .forbidden
			case 404: return .notFound
			case 500: return .serverError
			case 503: return .serviceUnavailable
			default: return .unknown
		}
	}
	
	private func assertTerminatedSession(data: Data) -> Bool {
		let message = String(decoding: data, as: UTF8.self)
		return message == "terminated_session"
	}
}
