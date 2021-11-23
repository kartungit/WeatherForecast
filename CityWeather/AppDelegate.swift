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
	private lazy var navigationController = UINavigationController()
	private var coordinator: NavigationControllerCoordinator!
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		
		coordinator = NavigationControllerCoordinator(navigator: navigationController)
		coordinator.home()
		
		window?.makeKeyAndVisible()
		
		return true
	}
}
