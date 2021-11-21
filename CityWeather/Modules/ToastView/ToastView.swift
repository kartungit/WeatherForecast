//
//  ToastViewController.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//

import UIKit

enum ToastType {
	case loading
	case error(String)
	case text(String)
}

class ToastView: UIView {
	private var type: ToastType = .loading
	
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
	
	required init() {
		super.init(frame: .zero)
		setupLayout()
		setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func present(with type: ToastType) {
		self.type = type
		switch type {
			case .loading:
				self.indicator.startAnimating()
				toogleHideViewWithAnimation(shouldShow: true)
			case .error(let errorText):
				self.lbText.text = errorText
				toogleHideViewWithAnimation(shouldShow: true)

			case .text(let text):
				self.lbText.text = text
				toogleHideViewWithAnimation(shouldShow: true)
				DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {[weak self] in
					guard let self = self,
						  case .text = self.type else { return }
					self.toogleHideViewWithAnimation()
				})
		}
	}
	
	private func toogleHideViewWithAnimation(shouldShow: Bool = false) {
		if shouldShow {
			self.alpha = 0
			self.isHidden = false
			UIView.animate(withDuration: 1) {
				self.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 1, animations: {
				self.alpha = 0
			}) { (finished) in
				self.isHidden = true
			}
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
}