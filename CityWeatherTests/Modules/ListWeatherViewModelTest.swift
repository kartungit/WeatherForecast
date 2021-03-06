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
import Moya
@testable import CityWeather

class ListWeatherViewModelTest: XCTestCase {
	var scheduler: TestScheduler!
	var sut: ListWeatherViewModel!
	
	var input: ListWeatherViewModel.Input!
	var output: ListWeatherViewModel.Output!
	private var disposeBag: DisposeBag!
	
	let searchTest$ = PublishSubject<String>()
	
	
	func test_viewModelInit_recieveSearchText_shorterThan3_notEmmitFetch() {
		makeSUT()
		
		let toastTextTest = scheduler.createObserver(String.self)
		output.cityCountryText.drive(toastTextTest).disposed(by: disposeBag)
		
		scheduler.createColdObservable([.next(10, "a")])
			.bind(to: searchTest$)
			.disposed(by: disposeBag)
		
		scheduler.start()
		XCTAssertEqual(toastTextTest.events, [])
	}
	
	func test_viewModelInit_searchTwice_withInputNotChange_fetchOnce() {
		makeSUT()
		
		let toastTextTest = scheduler.createObserver(String.self)
		output.cityCountryText.drive(toastTextTest).disposed(by: disposeBag)
		let listDayWeather = scheduler.createObserver([DayWeatherModel].self)
		output.dayWeatherList.drive(listDayWeather).disposed(by: disposeBag)

		scheduler.createColdObservable([.next(10, "abc"),
										.next(20, "abc")])
			.bind(to: searchTest$)
			.disposed(by: disposeBag)
		
		scheduler.start()
		XCTAssertEqual(toastTextTest.events, [.next(10, "Ho Chi Minh City, VN")])
		XCTAssertEqual(listDayWeather.events.count, 1)
	}
	
	func test_viewModelInit_withNetworkManager_searchTwice_receiveTwice() {
		makeSUT()
		
		let toastTextTest = scheduler.createObserver(String.self)
		output.cityCountryText.drive(toastTextTest).disposed(by: disposeBag)
		
		scheduler.createColdObservable([.next(10, "abc"),
										.next(20, "abcd")])
			.bind(to: searchTest$)
			.disposed(by: disposeBag)
		
		scheduler.start()
		XCTAssertEqual(toastTextTest.events, [.next(10, "Ho Chi Minh City, VN"),
											  .next(20, "Ho Chi Minh City, VN")])
	}
	
	func test_viewModelInit_requestApiWithError_emmitError() {
		let stubErrorNetwork = StubWeatherErrorNetwork(isMock: true)
		makeSUT(stubNetwork: stubErrorNetwork)
		
		let errorTest = scheduler.createObserver(ApiError?.self)
		output.error.drive(errorTest).disposed(by: disposeBag)
		let toastTextTest = scheduler.createObserver(String.self)
		output.cityCountryText.drive(toastTextTest).disposed(by: disposeBag)
		
		scheduler.createColdObservable([.next(10, "abc"),
										.next(20, "a"),
										.next(30, "abcd")])
			.bind(to: searchTest$)
			.disposed(by: disposeBag)
		
		scheduler.start()
		XCTAssertEqual(errorTest.events, [.next(10, ApiError.notFound),
										  .next(30, ApiError.notFound)])
		XCTAssertEqual(toastTextTest.events, [.next(10, ""),
											  .next(30, "")])
	}
	
	private func makeSUT(stubNetwork: ApiManagement = WeatherNetworkApiManager(isMock: true)) {
		let stubNetwork = stubNetwork
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		
		sut = ListWeatherViewModel(dataManager: stubNetwork,
								   presenterFactory: NetworkWeatherPresenterFactory())
		input = ListWeatherViewModel.Input(searchText: searchTest$.asObservable())
		output = sut.transform(input)
	}
}

class StubWeatherErrorNetwork: WeatherNetworkApiManager {
	override func getCityWeather(city: String) -> Single<WeatherNetworkModel>{
		
		let customEndpointClosure = { (target: WeatherService) -> Endpoint in
			return Endpoint(url: URL(target: target).absoluteString,
							sampleResponseClosure: { .networkResponse(CodeError.notFound.rawValue, Data()) },
							method: target.method,
							task: target.task,
							httpHeaderFields: target.headers)
		}
		
		self.provider = MoyaProvider<WeatherService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
		
		return super.getCityWeather(city: city)
	}
}
