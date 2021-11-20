//
//  BaseViewModel.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import Foundation
import RxSwift

protocol ViewModelType {
	associatedtype Input
	associatedtype Output
	
	func transform(_ input: Input) -> Output
}

class BaseViewModel {
	
	
}
