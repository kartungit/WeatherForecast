//
//  ToastViewController.swift
//  CityWeather
//
//  Created by ThinhMH on 21.11.2021.
//

import UIKit

enum ToastType {
	case loading(Bool)
	case error(String)
	case text(String)
}

class ToastView: UIView {
	private var type: ToastType = .loading(true)
	
	private lazy var lbText: UILabel = {
		let label = AccessibilityLabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.accessibilityValue = "Error message"
		self.addSubview(label)
		
		return label
	}()
	
	private lazy var indicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .gray)
		indicator.hidesWhenStopped = true
		self.addSubview(indicator)
		return indicator
	}()
	
	let dispatchGroup = DispatchGroup()
	
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
			case .loading(let isLoading):
				if isLoading {
					self.indicator.startAnimating()
					self.lbText.text = ""
					toogleHideViewWithAnimation(shouldShow: true)
				} else {
					self.indicator.stopAnimating()
				}
			case .error(let errorText):
				self.lbText.text = errorText
				toogleHideViewWithAnimation(shouldShow: true)

			case .text(let text):
				self.lbText.text = text
				self.dispatchGroup.enter()
				toogleHideViewWithAnimation(shouldShow: true)
				DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {[weak self] in
					guard let self = self else { return }
					self.dispatchGroup.leave()
				})
				
				self.dispatchGroup.notify(queue: .main) {[weak self] in
					guard let self = self,
						  case .text = self.type else { return }
					self.toogleHideViewWithAnimation()
				}
		}
		
	}
	
	private func toogleHideViewWithAnimation(shouldShow: Bool = false) {
		if shouldShow {
			self.alpha = 0
			UIView.animate(withDuration: 0.5) {
				self.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.5, animations: {
				self.alpha = 0
			}) { _ in
			}
		}
	}
	
	private func setupUI() {
		self.backgroundColor = UIColor(red: 236/225, green: 110/225, blue: 76/225, alpha: 1)
		self.layer.cornerRadius = 30
		self.alpha = 0
	}

	private func setupLayout() {
		
		lbText.snp.makeConstraints { make in
			make.leading.top.trailing.bottom.equalToSuperview().inset(24)
			make.centerX.centerY.equalToSuperview()
		}
		
		indicator.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		setupAccessibilityIdentification()
	}
	
	private func setupAccessibilityIdentification() {
		self.accessibilityIdentifier = AccessibilityID.Common.Toast.view
		lbText.accessibilityIdentifier = AccessibilityID.Common.Toast.label
		indicator.accessibilityIdentifier = AccessibilityID.Common.Toast.indicator
	}
}
