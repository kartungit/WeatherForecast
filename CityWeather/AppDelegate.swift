//
//  AppDelegate.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	 var window: UIWindow?
		var navigationController: UINavigationController?
	 
	 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		 
		 window = UIWindow(frame: UIScreen.main.bounds)
		
		let viewModel = ListWeatherViewModel(dataManager: WeatherNetworkApiManager(), presenterFactory: NetworkWeatherPresenterFactory())
		let viewController = ListWeatherViewController(viewModel: viewModel)
		navigationController = UINavigationController(rootViewController: viewController)

		 window?.rootViewController = navigationController
		 window?.makeKeyAndVisible()
		 
		 
		 return true
	 }
 }
