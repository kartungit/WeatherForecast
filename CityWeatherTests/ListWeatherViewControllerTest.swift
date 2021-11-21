//
//  ListWeatherViewControllerTest.swift
//  CityWeatherTests
//
//  Created by ThinhMH on 22.11.2021.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import CityWeather

class ListWeatherViewControllerTest: XCTestCase {
	var scheduler: TestScheduler!
	private var disposeBag: DisposeBag!

	func test_viewDidLoad_ShowStatusCell() {
		XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 1)
	}
	
	private func makeSUT() -> ListWeatherViewController {
		let stubMoyaNetwork = WeatherNetworkApiManager(isMock: true)
		let viewModel = ListWeatherViewModel(dataManager: stubMoyaNetwork,
											 presenterFactory: NetworkWeatherPresenterFactory())
		let sut = ListWeatherViewController(viewModel: viewModel)
		sut.loadViewIfNeeded()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		
		return sut
	}
}
