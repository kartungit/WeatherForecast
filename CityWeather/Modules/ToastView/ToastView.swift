//
//  ToastViewController.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//

import UIKit

enum ToastType {
	case loading
	case text(String)
}

class ToastView: UIView {
	private var textToast: String
	private var showToast: (Bool) -> Void
	
	private lazy var lbText: UILabel = {
		let label = UILabel()
		label.textColor = .black
		
		self.addSubview(label)
		return label
	}()
	
	private lazy var indicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		
		self.addSubview(indicator)
		return indicator
	}()
	
	required init(textToast: String, showToast: @escaping (Bool) -> Void) {
		self.textToast = textToast
		self.showToast = showToast
		super.init(frame: .zero)
		setupLayout()
		setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func present(with type: ToastType) {
		switch type {
			case .loading:
				self.indicator.startAnimating()
			case .text(let text):
				self.lbText.text = text
				toogleHideViewWithAnimation()
		}
	}

	private func setupUI() {
		self.backgroundColor = .lightGray
		self.layer.cornerRadius = 30
	}

	private func setupLayout() {
		self.snp.makeConstraints { make in
			make.height.equalTo(60)
		}
		
		lbText.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
		indicator.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
	}
	
	private func toogleHideViewWithAnimation() {
		if self.isHidden == false {
			UIView.animate(withDuration: 1, animations: {
				self.alpha = 0
			}) { (finished) in
				self.isHidden = true
			}
		} else {
			self.alpha = 0
			self.isHidden = false
			UIView.animate(withDuration: 1) {
				self.alpha = 1
			}
		}
	}
}
