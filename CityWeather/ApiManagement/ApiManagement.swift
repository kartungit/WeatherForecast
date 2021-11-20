//
//  ApiManagement.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import RxSwift

protocol ApiManagement {
	func getCityWeather(city: String) -> Single<String>
}
