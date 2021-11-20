//
//  ViewController.swift
//  CityWeather
//
//  Created by ThinhMH on 20.11.2021.
//

import UIKit
import SnapKit
import RxSwift

class ListWeatherViewController: UIViewController {
	private var viewModel: ListWeatherViewModel!
	private let disposeBag = DisposeBag()
	
	private lazy var tfSearch: UITextField = {
		let textfield = UITextField()
		textfield.backgroundColor = .gray
		view.addSubview(textfield)
		return textfield
	}()
	
	
	init(viewModel: ListWeatherViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupLayout()
		bindViewModel()
	}
	
	private func setupLayout() {
		tfSearch.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		view.backgroundColor = .cyan
	}
	
	func bindViewModel() {
		guard let viewModel = viewModel else { return }
		let textSearch = tfSearch.rx.text.orEmpty.map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}.asObservable()
		
		let input = ListWeatherViewModel.Input(searchText: textSearch)
		
		let output = viewModel.transform(input)
		
		output.toastText.drive(onNext: { text in
			print(text)
		}).disposed(by: disposeBag)
	}

}

