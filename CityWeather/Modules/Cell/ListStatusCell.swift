//
//  ListStatusCell.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import UIKit

enum ListStatusType {
	case empty
	case error(String)
	
	var statusText: String {
		switch self {
			case .empty:
				return "Type in search field to start"
			case .error(let error):
				return error
		}
	}
}

class ListStatusCell: UITableViewCell {
	lazy var lbStatus: UILabel = {
		let label = AccessibilityLabel()
		label.textAlignment = .center
		label.font = .preferredFont(forTextStyle: .title1)

		contentView.addSubview(label)
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		self.selectionStyle = .none
		self.backgroundColor = .systemGray
	}
	
	private func setupLayout() {
		lbStatus.snp.makeConstraints { make in
			make.top.bottomMargin.equalToSuperview().inset(200)
			make.leading.trailing.equalToSuperview().inset(16)
		}
	}
	
	func updateCell(with type: ListStatusType) {
		lbStatus.text = type.statusText
		
		
	}
}
