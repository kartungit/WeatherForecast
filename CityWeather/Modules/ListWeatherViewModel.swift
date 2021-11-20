//
//  ListWeatherViewModel.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import RxSwift
import RxCocoa

class ListWeatherViewModel: ViewModelType {
	struct Input {
		let searchText: Observable<String>
	}
	
	struct Output {
		let toastText: Driver<String>
	}
	
	private let dataManager: ApiManagement
	private let viewPresentable = BehaviorRelay<WeatherPresentModel?>(value: nil)
	
	init(dataManager: ApiManagement) {
		self.dataManager = dataManager
	}
	
	func transform(_ input: Input) -> Output {
		let viewPresentable = input.searchText
			.flatMap({[weak self] text -> Single<String> in
				guard let self = self else { return .error(APIError.unknown)}
				return self.dataManager.getCityWeather(city: text)
					.map{$0.locationToastText}
		})
		return Output(toastText: viewPresentable.asDriver(onErrorJustReturn: ""))
	}
}

