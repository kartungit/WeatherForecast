//
//  UISearchBar+ext.swift
//  CityWeather
//
//  Created by ThinhMH on 25.11.2021.
//

import UIKit

extension UISearchBar {
	var textField: UITextField {
		if #available(iOS 13, *) {
			return searchTextField
		} else {
			return self.value(forKey: "_searchField") as! UITextField
		}
	}
	
	var cancelButton : UIButton {
		return self.value(forKey: "cancelButton") as! UIButton
	}
}

