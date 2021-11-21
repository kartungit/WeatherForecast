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
	
	private lazy var phantomToast: ToastView = {
		let toastView = ToastView()
		
		view.addSubview(toastView)
		return toastView
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
			make.leading.trailing.equalToSuperview().inset(16)
			make.height.equalTo(60)
			make.top.equalToSuperview().inset(60)
		}
		
		phantomToast.snp.makeConstraints { make in
			make.top.equalTo(tfSearch.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview().inset(32)
		}
		view.backgroundColor = .cyan
	}
	
	func delayedHideToast(isShowing: Bool) {
		if isShowing {
			phantomToast.isHidden = true
		}
	}
	
	private func toastShouldHide(isShowing: Bool) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
			guard let self = self else { return }
			self.delayedHideToast(isShowing: isShowing)
		})
	}
	
	private func bindViewModel() {
		guard let viewModel = viewModel else { return }
		let textSearch = tfSearch.rx.text.orEmpty.map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}.asObservable()
		
		let input = ListWeatherViewModel.Input(searchText: textSearch)
		
		let output = viewModel.transform(input)
		
		output.cityCountryText
			.filter{$0.count > 0}
			.drive(onNext: {[weak self] text in
			guard let self = self else { return }
			self.phantomToast.present(with: .text(text))
		}).disposed(by: disposeBag)
		
		output.error.drive(onNext: {[weak self] error in
			guard let self = self,
				  let error = error else { return }
			self.phantomToast.present(with: .error(error.localizedMessage))
		}).disposed(by: disposeBag)
	}

}

