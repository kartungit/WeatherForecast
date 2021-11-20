//
//  TestResources.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation

class TestResources {
	static func readJSON(name: String) -> Data! {
		let bundle = Bundle(for: TestResources.self)
		guard let url = bundle.url(forResource: name, withExtension: "json") else { return nil }
		
		do {
			return try Data(contentsOf: url, options: .mappedIfSafe)
		}
		catch {
			print("Error occurred parsing test data")
			return nil
		}
	}
}

protocol ResourcesFileName {
	var mockData: Data! { get }
}

enum UserTestData: String, ResourcesFileName {
	var mockData: Data! {
		return TestResources.readJSON(name: self.rawValue)
	}
	
	func mockObject<ReturnedObject: Decodable>(ObjectReturned: ReturnedObject.Type) -> ReturnedObject {
			let decoder = JSONDecoder()
			let object = try! decoder.decode(ReturnedObject.self, from: mockData)

			return object
	}
	
	case empty = "empty"
	case saigonWeather = "SaigonWeather"
}
