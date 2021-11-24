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
	private let disposeBag = DisposeBag()
	private var viewModel: ListWeatherViewModel!
	internal var outputViewModel: ListWeatherViewModel.Output!

	private(set) lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemGray
		tableView.alwaysBounceVertical = false
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
		tableView.register(DayWeatherCell.self, forCellReuseIdentifier: "ItemCell")
		tableView.register(ListStatusCell.self, forCellReuseIdentifier: "StatusCell")

		tableView.accessibilityIdentifier = AccessibilityID.ListWeather.tableView
		view.addSubview(tableView)
		return tableView
	}()
	
	private lazy var phantomToast: ToastView = {
		let toastView = ToastView()
		
		view.addSubview(toastView)
		return toastView
	}()
	
	private let searchController = UISearchController(searchResultsController: nil)
	private var dayWeatherItems: [DayWeatherModel] = []
	let textSearch$ = PublishSubject<String>()

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
		setupUI()
		bindViewModel()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		navigationItem.title = "Weather Forecast"
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.hidesNavigationBarDuringPresentation = false
	}

	private func setupLayout() {
		navigationItem.searchController = searchController

		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
			make.bottom.equalToSuperview()
		}
		
		phantomToast.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		setupAccessibilityIdentification()
	}
	
	private func setupAccessibilityIdentification() {
		self.navigationController?.navigationBar.accessibilityIdentifier = AccessibilityID.ListWeather.navigationBar
		searchController.isAccessibilityElement = true
		searchController.searchBar.textField.accessibilityIdentifier = AccessibilityID.ListWeather.searchTextField
	}
	
	private func bindViewModel() {
		guard let viewModel = viewModel else { return }
		searchController.searchBar.rx.text.orEmpty
			.map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
			.debounce(RxTimeInterval.milliseconds(300),
					  scheduler: MainScheduler.instance)
			.bind(to: textSearch$)
			.disposed(by: disposeBag)
		
		let input = ListWeatherViewModel.Input(searchText: textSearch$)
		
		let output = viewModel.transform(input)
		
		output.cityCountryText
			.filter{$0.count > 0}
			.drive(onNext: {[weak self] text in
			guard let self = self else { return }
			self.phantomToast.present(with: .text(text))
		}).disposed(by: disposeBag)
		
		output.isLoading.drive(onNext: {[weak self] isLoading in
			guard let self = self else { return }
			self.phantomToast.present(with: .loading(isLoading))
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
		return dayWeatherItems.count == 0 ? 1 : dayWeatherItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if dayWeatherItems.count == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as? ListStatusCell
			cell?.updateCell(with: .empty)
			tableView.separatorStyle = .none
			return cell ?? UITableViewCell()
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? DayWeatherCell
			tableView.separatorStyle = .singleLine
			cell?.updateCell(item: dayWeatherItems[indexPath.row])
			return cell ?? UITableViewCell()
		}
	}
}
