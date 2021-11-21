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
		let cityCountryText: Driver<String>
		let dayWeatherList: Driver<[DayWeatherModel]>
		let error: Driver<APIError?>
	}
	static let MIN_SEARCH_TEXT = 3
	static let LOCATION_NOT_VALID = "Location is not valid"
	private let dataManager: ApiManagement
	private let viewPresentable = PublishRelay<[DayWeatherModel]>()
	private let outputToast = BehaviorRelay<String>(value: "Welcome, type to start")
	private let errorTracker = PublishSubject<APIError?>()
	private let disposeBag = DisposeBag()
	
	init(dataManager: ApiManagement) {
		self.dataManager = dataManager
	}
	
	func transform(_ input: Input) -> Output {
		input.searchText
			.filter{$0.count >= ListWeatherViewModel.MIN_SEARCH_TEXT}
			.flatMapLatest({[weak self] text -> Single<WeatherPresentModel> in
				guard let self = self else { return .error(APIError.unknown)}
				return self.dataManager.getCityWeather(city: text)
					.map{$0.weatherPresenter()}
					.catchError ({ [weak self] error in
						guard let self = self,
						let error = error as? APIError else { return .error(APIError.unknown)}
							self.errorTracker.onNext(error)
						return .just(WeatherPresentModel.errorView())
			  })
			}).subscribe(onNext:{[weak self] presentModel in
				guard let self = self else { return }
				self.outputToast.accept(presentModel.locationToastText)
				self.viewPresentable.accept(presentModel.dayList)
			}).disposed(by: disposeBag)
		
		return Output(cityCountryText: outputToast.asDriver(onErrorJustReturn: ""),
					  dayWeatherList: viewPresentable.asDriver(onErrorJustReturn: []),
					  error: errorTracker.asDriver(onErrorJustReturn: nil))
	}
}

