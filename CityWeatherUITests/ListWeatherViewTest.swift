//
//  ListWeatherViewTest.swift
//  CityWeatherUITests
//
//  Created by ThinhMH on 24.11.2021.
//

import XCTest

class ListWeatherViewTest: XCTestCase {
	private var app: XCUIApplication!
	private var navigationBar: XCUIElement!
	private var searchField: XCUIElement!
	private var tableView: XCUIElement!

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		try super.setUpWithError()
		
		app = XCUIApplication()
		app.launch()
		
		navigationBar = app.navigationBars["navigationBar"]
		searchField = navigationBar.searchFields["tfSearch"]

		tableView = app.tables["tableView"]
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		
		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		app = nil
		try super.tearDownWithError()
	}

	func test_openApp_showTextSearchAndEmptyList_withBigMessage() {
		let emptyCell = tableView.cells["vwEmpty"]
		XCTAssertTrue(emptyCell.exists)
		XCTAssertTrue(searchField.exists)
	}
	
	func test_navigationItems_andDismissView_areEnable() {
		XCTAssertTrue(searchField.isEnabled, "Search text field is not enable to edit")
		searchField.tap()
		
		let dismissView = app.otherElements["PopoverDismissRegion"]
		XCTAssertTrue(dismissView.isEnabled, "Dismiss View is not enable to tap")
	}
	
	func test_searchBar_CanTypeText_ToastShowIndicator() {
		searchField.tap()
		searchField.typeText("saigon")
		
		let toastView = app.otherElements["vwToast"]
		let indicator = toastView.activityIndicators["vwIndicator"]
		
		expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: indicator, handler: nil)
		waitForExpectations(timeout: 3, handler: nil)
	}
	
	func test_searchBar_typeANotValidCityName_ToastShowMessage_cityNotFound() {
		searchField.tap()
		searchField.typeText("notAValidCity")
		
		let toastView = app.otherElements["vwToast"]
		let lbToast = toastView.staticTexts["lbToast"]
		XCTAssertTrue(toastView.waitForExistence(timeout: 1), "Toast was not present while searching")
		XCTAssertTrue(lbToast.waitForExistence(timeout: 4), "Label Toast was not present while searching")
		XCTAssertEqual(lbToast.label, "city not found", "Wrong message when input a inValid city name")
	}
		
	func test_searchBar_typeValidCityName_receiveValues_WeatherCellPresnted() {
		searchField.tap()
		searchField.typeText("tok")

		let weatherCell = tableView.cells["vwWeatherCell"]
		let toastView = app.otherElements["vwToast"]
		let lbToast = toastView.staticTexts["lbToast"]
		let lable1 = lbToast.label
		XCTAssertTrue(weatherCell.waitForExistence(timeout: 4), "WeatherCell was not present after searching")
		
		searchField.typeText("yo")
		let lable2 = lbToast.label
		expectation(for: NSPredicate(format: "label == \"Tokyo, JP\""), evaluatedWith: lbToast, handler: nil)
		waitForExpectations(timeout: 2, handler: nil)

		XCTAssertNotEqual(lable1, lable2, "Toast was not updated while searching twice")
	}
}
