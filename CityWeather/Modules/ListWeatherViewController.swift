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
		textfield.backgroundColor = .systemGray4
		view.addSubview(textfield)
		
		return textfield
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemGray4
		tableView.dataSource = self
		tableView.register(DayWeatherCell.self, forCellReuseIdentifier: "ItemCell")

		view.addSubview(tableView)
		return tableView
	}()
	
	private lazy var phantomToast: ToastView = {
		let toastView = ToastView()
		
		tableView.addSubview(toastView)
		return toastView
	}()
	
	private var dayWeatherItems: [DayWeatherModel] = []
	
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
		tableView.snp.makeConstraints { make in
			make.top.equalTo(tfSearch.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		phantomToast.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(16)
			make.leading.trailing.equalTo(self.view).inset(16)
		}
		
		view.backgroundColor = .cyan
	}
	
	private func bindViewModel() {
		guard let viewModel = viewModel else { return }
		let textSearch = tfSearch.rx.text.orEmpty.map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}			.debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance).asObservable()
		
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
		
		output.dayWeatherList.drive(onNext: {[weak self] items in
			guard let self = self else { return }
			self.dayWeatherItems = items
			self.tableView.reloadData()
		}).disposed(by: disposeBag)
	}

}

extension ListWeatherViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dayWeatherItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? DayWeatherCell
		cell?.updateCell(item: dayWeatherItems[indexPath.row])
		return cell ?? UITableViewCell()
	}
}
