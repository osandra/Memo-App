//
//  UIFont+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/19.
//

import UIKit
extension UIFont {
    struct MyFont {
        static func SpoqeRegular(customSize: CGFloat) -> UIFont {
            return UIFont(name: "SpoqaHanSansNeo-Regular", size: customSize)!
        }
        static func SpoqeMedium(customSize: CGFloat) -> UIFont {
            return UIFont(name: "SpoqaHanSansNeo-Medium", size: customSize)!
        }
    }
}

