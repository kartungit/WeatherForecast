//
//  ListWeatherViewModelTest.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RxTest
@testable import CityWeather

class ListWeatherViewModelTest: XCTestCase {
	var scheduler: TestScheduler!
	var sut: ListWeatherViewModel!

	var input: ListWeatherViewModel.Input!
	var output: ListWeatherViewModel.Output!
	private var disposeBag: DisposeBag!

	let searchTest$ = PublishSubject<String>()
	
	func test_viewModelInit_withNetworkManager() {
		let stubNetwork = WeatherNetworkApiManager<WeatherNetworkModel>(isMock: true)
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()

		sut = ListWeatherViewModel(dataManager: stubNetwork)
		input = ListWeatherViewModel.Input(searchText: searchTest$.asObservable())
		output = sut.transform(input)
		let toastTextTest = scheduler.createObserver(String.self)
		
		output.toastText.drive(toastTextTest).disposed(by: disposeBag)

		scheduler.createColdObservable([.next(10, "abc")])
			.bind(to: searchTest$)
			.disposed(by: disposeBag)
		
		scheduler.start()
		XCTAssertEqual(toastTextTest.events.count, 1)
	}
}
