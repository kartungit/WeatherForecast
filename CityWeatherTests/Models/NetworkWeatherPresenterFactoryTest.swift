//
//  NetworkWeatherPresenterFactoryTest.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//

import XCTest
@testable import CityWeather

class NetworkWeatherPresenterFactoryTest: XCTestCase {
	func test_weatherPresenterFactory_generateWeatherPresenter() {
		let sut = NetworkWeatherPresenterFactory()
		let stubModel = UserTestData.saigonWeather.mockObject(ObjectReturned: WeatherNetworkModel.self)
		
		let presentable = sut.weatherPresenter(model: stubModel)
		let stubDay = DayWeatherModel(date: "Date: Sat, 20 Nov 2021",
									  aveTemp: "Average Temperature: 27°C",
									  pressure: "Pressure: 1007",
									  humidity: "Humidity: 72%",
									  description: "Description: moderate rain",
									  imgUrl: "\(AppConfig.BASE_IMG_SOURCE)10d@2x.png",
									  imageAccessibilityLable: "moderate rain")
		XCTAssertEqual(presentable.dayList.count, 7)
		XCTAssertEqual(presentable.dayList.first!.date, stubDay.date)
		XCTAssertEqual(presentable.dayList.first!.aveTemp, stubDay.aveTemp)
		XCTAssertEqual(presentable.dayList.first!.pressure, stubDay.pressure)
		XCTAssertEqual(presentable.dayList.first!.humidity, stubDay.humidity)
		XCTAssertEqual(presentable.dayList.first!.description, stubDay.description)
		XCTAssertEqual(presentable.dayList.first!.imgUrl, stubDay.imgUrl)
		XCTAssertEqual(presentable.dayList.first!.imageAccessibilityLable, stubDay.imageAccessibilityLable)
	}
}
