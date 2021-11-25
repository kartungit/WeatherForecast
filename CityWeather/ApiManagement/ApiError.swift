//
//  ApiError.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import Alamofire
import Moya

enum CodeError: Int, Error{
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
	
	var title: String {
		return "Error response"
	}
	
	var errorResponse: ErrorResponse {
		return ErrorResponse(message: localizedMessage,
							 title: title,
							 statusCode: rawValue)
		
	}
}

class ApiErrorManagement {
	func checkResponse(_ response: Response) -> CodeError {
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
	
	func parseError(error: Error) -> ApiError {
		guard let moyaError = error as? MoyaError else {
			return ApiError.serverError(response: CodeError.unknown.errorResponse)
		}
		
		switch moyaError {
			case .underlying(let error, _):
				let underlyingCode: Int
				if let underlyingError = (error as? Alamofire.AFError)?.underlyingError {
						underlyingCode = (underlyingError as NSError).code
					} else if let alamofireError = error as? Alamofire.AFError {
						underlyingCode = (alamofireError as NSError).code
					} else {
						underlyingCode = (error as NSError).code
					}
				return ApiError.networkError(code: underlyingCode)
			case .statusCode(let response):
				let codeError = checkResponse(response)
				return ApiError.serverError(response: codeError.errorResponse)
			default:
				print(moyaError)
				return ApiError.serverError(response: CodeError.unknown.errorResponse)
		}
	}
}

enum ApiError: Error {
	case serverError(response: ErrorResponse)
	case networkError(code: Int)
	
	var title: String {
		switch self {
			case .serverError(let response): return response.title ?? ""
			case .networkError: return "Network Error"
		}
	}

	var message: String {
		switch self {
			case .serverError(let response): return response.message ?? ""
			case .networkError(let code): return "Unknown error with code: \(code)"
		}
	}
	
	var description: String {
		return "\(title): \(message)"
	}
}
