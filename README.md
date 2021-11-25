# Building iOS assignment


![CI](https://github.com/essentialdevelopercom/quiz-app/workflows/CI/badge.svg)

## Brief explanation for the software development principles, patterns & practices being applied</h2>

	- MVVM UI Pattern
	
	- Clean Architecture with SOLID
	
	- Dependency Injection design pattern with Coordinator as Composition Root
	
## Brief explanation for the code folder structure and the key Objective-C/Swift libraries and frameworks being used</h2>

- CityWeather
	- Coordinator - Composition Root define flow in app.
	- CommonView - Some custom UI for convenient using
	- Base - Base things using project wide ( type for ViewModel, Constant )
	- Modules - Mainly part that handle UI render, accept user interact.
	- Models
		- Presentable - Protocol factory to generate view's presentable instance, concrete implementation for ListWeatherView
		- Network - Scaffold object to fetch data from network
	- ApiManagement
		- TargetService - Target to create object that determined request network 
		- ApiManagent - Functionally data desire in application
		- WeatherNetworkApiManager - Concrete implementation *ApiManagent* for specific fetch data from OpenWeather API ( inheritance from *MoyaNetwork* )
	- Network
		- CacheManagement - Simple Cache which help *MoyaNetwork* reduce redundancy request in a period of time	
		- MoyaNetwork - Base class for execution of inherited useCase
		- ApiError + ErrorResponse - Simplify network and response error from server
- CityWeatherTests - Unit Test for logic part with RXTest, Stub network, Mock data
- CityWeatherUITests - UI Test cases: initial, search emtpy, network error, search successful.

- Project is supported from excellent and trusted libraries: 

	- UI layout contraints: [Snapkit](https://github.com/SnapKit/SnapKit)
	
	- Reactive Programing: [RXSwift](https://github.com/ReactiveX/RxSwift)
	
	- Network Request: [Moya](https://github.com/Moya/Moya)
	
	- Image loader: [Kingfisher](https://github.com/onevcat/Kingfisher)
	
##  All the required steps in order to get the application run on local computer</h2>

	- Clone the repository, checkout main branch
	
	- Open CityWeather.xcworkspace in XCode (Recommend MacOS 11.4, XCode 12.5.1)
	
	- Wait for XCode to resovle Swift Package and to Index project.
	
	- Run CityWeather.xcworkspace on simulator or device
	
## Checklist of items the candidate has done.

- [x] 1. Programming language: Swift is required, Objective-C is optional.
- [x] 2. Design app's architecture (recommend VIPER or MVP, MVVM but not mandatory)
- [x] 3. UI should be looks like in attachment.
- [x] 4. Write UnitTests
- [x] 5. Acceptance Tests
- [x] 6. Exception handling
- [x] 7. Caching handling
- [x] 8. Accessibility for Disability Supports:
	a. VoiceOver: Use a screen reader.
	b. Scaling Text: Display size and font size: To change the size of items on your
	screen, adjust the display size or font size.
- [x] 9. Entity relationship diagram for the database and solution diagrams for the components,
	infrastructure design if any
- [x] 10. Readme


This project has done with inspiration from [SwiftHub](https://github.com/khoren93/SwiftHub), [QuizApp](https://github.com/essentialdevelopercom/quiz-app), [Stackoverflow](https://stackoverflow.com/)

