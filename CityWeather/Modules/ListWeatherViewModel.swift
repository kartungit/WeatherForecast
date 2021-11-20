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
		let error: Driver<APIError?>
	}
	static let MIN_SEARCH_TEXT = 3
	static let LOCATION_NOT_VALID = "Location is not valid"
	private let dataManager: ApiManagement
	private let viewPresentable = PublishRelay<String>()
	private let errorTracker = PublishSubject<APIError?>()
	private let disposeBag = DisposeBag()
	
	init(dataManager: ApiManagement) {
		self.dataManager = dataManager
	}
	
	func transform(_ input: Input) -> Output {
		input.searchText.debug("THINH DEBUG")
			.filter{$0.count >= ListWeatherViewModel.MIN_SEARCH_TEXT}
			.flatMapLatest({[weak self] text -> Observable<String> in
				guard let self = self else { return .error(APIError.unknown)}
				return self.dataManager.getCityWeather(city: text)
					.map{$0.locationToastText}.asObservable()
			}).catchError ({ [weak self] error in
				guard let self = self,
					  let error = error as? APIError else { return .error(APIError.unknown)}
				self.errorTracker.onNext(error)
				return .just(ListWeatherViewModel.LOCATION_NOT_VALID)
			}).subscribe(onNext:{[weak self] text in
				guard let self = self else { return }
				self.viewPresentable.accept(text)
			}).disposed(by: disposeBag)
		
		return Output(toastText: self.viewPresentable.asDriver(onErrorJustReturn: ""),
					  error: errorTracker.asDriver(onErrorJustReturn: nil))
	}
}

