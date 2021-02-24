//
//  UILabel+extension.swift
//  HealingMoment
//
//  Created by heawon on 2021/02/24.
//

import UIKit

extension UILabel {
    static func makeMediumLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(named: "darkmodelabel")
        label.font = UIFont.MyFont.SpoqeMedium(customSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    static func makeRegularLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(named: "darkmodelabel")
        label.font = UIFont.MyFont.SpoqeRegular(customSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
