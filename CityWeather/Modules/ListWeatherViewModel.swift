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
		let isLoading: Driver<Bool>
		let error: Driver<APIError?>
	}
	static let MIN_SEARCH_TEXT = 3
	private let disposeBag = DisposeBag()
	private let dataManager: ApiManagement
	private let presenterFactory: WeatherPresenterFactory
	private let viewPresentable = PublishRelay<[DayWeatherModel]>()
	private let outputToast = PublishRelay<String>()
	private let isLoading = PublishRelay<Bool>()
	private let errorTracker = PublishSubject<APIError?>()
	
	init(dataManager: ApiManagement, presenterFactory: WeatherPresenterFactory) {
		self.dataManager = dataManager
		self.presenterFactory = presenterFactory
	}
	
	func transform(_ input: Input) -> Output {
		input.searchText
			.filter{$0.count >= ListWeatherViewModel.MIN_SEARCH_TEXT}
			.distinctUntilChanged()
			.flatMapLatest({[weak self] text -> Single<WeatherPresentModel> in
				guard let self = self else { return .error(APIError.unknown)}
				self.isLoading.accept(true)
				return self.dataManager.getCityWeather(city: text)
					.map{[weak self] response -> WeatherPresentModel in
						guard let self = self else { return WeatherPresentModel.errorView()}
						return self.presenterFactory.weatherPresenter(model: response)}
					.catchError ({ [weak self] error in
						guard let self = self,
						let error = error as? APIError else { return .error(APIError.unknown)}
							self.errorTracker.onNext(error)
						return .just(self.presenterFactory.errorViewPresenter())
			  })
			}).subscribe(onNext:{[weak self] presentModel in
				guard let self = self else { return }
				self.isLoading.accept(false)
				self.outputToast.accept(presentModel.locationToastText)
				self.viewPresentable.accept(presentModel.dayList)
			}).disposed(by: disposeBag)
		
		return Output(cityCountryText: outputToast.asDriver(onErrorJustReturn: ""),
					  dayWeatherList: viewPresentable.asDriver(onErrorJustReturn: []),
					  isLoading: isLoading.asDriver(onErrorJustReturn: false),
					  error: errorTracker.asDriver(onErrorJustReturn: nil))
	}
}

