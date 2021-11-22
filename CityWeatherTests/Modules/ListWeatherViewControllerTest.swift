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

	func test_viewDidLoad_ShowsStatusCell() {
		let sut = makeSUT()

		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
		XCTAssertNotNil(sut.tableView.cell(at: 0) as? ListStatusCell)
	}
	
	func test_emptyDayItems_ShowsStatusCell() {
		let stubErrorNetwork = StubWeatherErrorNetwork(isMock: true)
		let sut = makeSUT(stubNetwork: stubErrorNetwork)

		let stubSearchText = PublishSubject<String>()
		
		stubSearchText.asObservable()
			.bind(to: sut.textSearch$).disposed(by: disposeBag)
		
		stubSearchText.onNext("abc")
		
		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
		XCTAssertNotNil(sut.tableView.cell(at: 0) as? ListStatusCell)
	}
	
	func test_fetchSuccess_ShowsSevenItems() {
		let stubSearchText = PublishSubject<String>()
		let sut = makeSUT()
		
		stubSearchText.asObservable()
			.bind(to: sut.textSearch$).disposed(by: disposeBag)
		
		stubSearchText.onNext("abc")
		
		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 7)
		XCTAssertNotNil(sut.tableView.cell(at: 0) as? DayWeatherCell)
	}
	
	private func makeSUT(stubNetwork: ApiManagement = WeatherNetworkApiManager(isMock: true)) -> ListWeatherViewController {
		let stubMoyaNetwork = stubNetwork
		let viewModel = ListWeatherViewModel(dataManager: stubMoyaNetwork,
											 presenterFactory: NetworkWeatherPresenterFactory())
		let sut = ListWeatherViewController(viewModel: viewModel)
		sut.loadViewIfNeeded()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		
		return sut
	}
}

extension UITableView {
	func cell(at row: Int) -> UITableViewCell? {
		return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
	}

}
