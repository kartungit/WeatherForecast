//
//  NavigationControllerCoordinator.swift
//  CityWeather
//
//  Created by ThinhMH on 23.11.2021.
//

import UIKit

protocol AppCoordinatorDelegate {
	func home()
}

class NavigationControllerCoordinator: AppCoordinatorDelegate {
	var navigator: UINavigationController
	
	init(navigator: UINavigationController) {
		self.navigator = navigator
	}
	
	func home() {
		let networkManager = WeatherNetworkApiManager(
			expireTime: ExpireTime.inSecond(10))
		let viewModel = ListWeatherViewModel(
			dataManager: networkManager,
			presenterFactory: NetworkWeatherPresenterFactory())
		let viewController = ListWeatherViewController(viewModel: viewModel)
		
		navigator.pushViewController(viewController, animated: true)
	}
}
