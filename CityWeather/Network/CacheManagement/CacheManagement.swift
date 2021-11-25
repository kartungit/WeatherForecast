//
//  CacheManagement.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import Foundation
import Moya

protocol Cachable: TargetType {
	var cacheManager: CacheManager { get set }
	var urlRequest: String { get }
	func getCache<T: Decodable>() -> T?
	func storeCache(expirable: Expirable)
}

final class CacheManager {
	static let shared = NSCache<NSString, Expirable>()
	
	let expireTime: ExpireTime
	init(expireTime: ExpireTime) {
		self.expireTime = expireTime
	}
	
	func get<T: Decodable>(key: String) -> T? {
		guard let expirable = CacheManager.shared.object(forKey: key as NSString) else { return nil }
		
		guard !cachedExpiredByNewDay(time: expirable.time) else {
			return nil
		}
		
		guard !hasExpired(time: expirable.time) else {
			CacheManager.shared.removeObject(forKey: key as NSString)
			return nil
		}
		
		return expirable.value as? T
	}
	
	func store(key: String, value: Expirable) {
		CacheManager.shared.setObject(value, forKey: key as NSString)
	}
	
	private func hasExpired(time: Date) -> Bool {
		switch expireTime {
			case .disable:
				return true
			case .inSecond(let second):
				let date = Date()
				return date > time.addingTimeInterval(TimeInterval(second))
		}
	}
	
	private func cachedExpiredByNewDay(time: Date) -> Bool {
		guard daysBetween(start: time, end: Date()) == 0 else {
			CacheManager.shared.removeAllObjects()
			return true
		}
		
		return false
	}
	
	private func daysBetween(start: Date, end: Date) -> Int {
		let calendar = Calendar.current
		
		// Replace the hour (time) of both dates with 00:00
		let date1 = calendar.startOfDay(for: start)
		let date2 = calendar.startOfDay(for: end)
		
		let a = calendar.dateComponents([.day], from: date1, to: date2)
		return a.value(for: .day)!
	}
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
