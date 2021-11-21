//
//  DayWeatherCell.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//

import UIKit
import Kingfisher

class DayWeatherCell: UITableViewCell {
	lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 8
		stackView.axis = .vertical
		
		contentView.addSubview(stackView)
		return stackView
	}()
	
	lazy var lbDate: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		stackView.addArrangedSubview(label)
		return label
	}()
	
	lazy var lbTemp: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		stackView.addArrangedSubview(label)
		return label
	}()
	
	lazy var lbPressure: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		stackView.addArrangedSubview(label)
		return label
	}()
	
	lazy var lbHumidity: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		stackView.addArrangedSubview(label)
		return label
	}()
	
	lazy var lbDescription: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		stackView.addArrangedSubview(label)
		return label
	}()
	
	lazy var imgIcon: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		contentView.addSubview(image)
		
		return image
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
		self.backgroundColor = .clear
		self.selectionStyle = .none
	}
	
	private func setupLayout() {
		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().inset(12)
			make.top.bottom.equalToSuperview().inset(16)
			make.trailing.equalTo(imgIcon.snp.leading)
		}
		
		imgIcon.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(24)
			make.centerY.equalToSuperview()
			make.height.width.equalTo(60)
		}
	}
	
	func updateCell(item: DayWeatherModel) {
		lbDate.text = item.date
		lbTemp.text = item.aveTemp
		lbPressure.text = item.pressure
		lbHumidity.text = item.humidity
		lbDescription.text = item.description
		let url = URL(string: item.imgUrl)!
		imgIcon.kf.setImage(with: url)
	}
	
}
