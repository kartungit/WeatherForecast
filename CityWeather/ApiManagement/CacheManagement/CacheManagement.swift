//
//  CacheManagement.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Foundation
import Moya

protocol Cachable: TargetType {
	var expireTime: ExpireTime { get set }
	var urlRequest: String { get }
	func getCache<T: Decodable>() -> T?
	func storeCache(expirable: Expirable)
}

final class CacheManager {
	static let shared = NSCache<NSString, Expirable>()
}

enum ExpireTime {
	case disable
	case inSecond(Int)
}

final class Expirable {
	let value: Any
	let time: Date
	
	init<T: Decodable>(value: T, time: Date) {
		self.value = value
		self.time = time
	}
}
