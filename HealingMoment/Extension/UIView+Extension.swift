//
//  UIView+Extension.swift
//  HealingMoment
//
//  Created by heawon on 2021/02/24.
//

import UIKit
extension UIView {
    static func defaultView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }
}
