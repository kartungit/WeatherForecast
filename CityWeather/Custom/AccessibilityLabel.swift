//
//  AccessibilityLabel.swift
//  CityWeather
//
//  Created by ThinhMH on 22.11.2021.
//

import UIKit

class AccessibilityLabel: UILabel {
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}
	
	private func commonInit() {
		self.textColor = .black
		self.numberOfLines = 0
		self.font = .preferredFont(forTextStyle: .body)
		self.adjustsFontForContentSizeCategory = true
	}
}
