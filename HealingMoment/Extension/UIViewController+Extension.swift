//
//  UIViewController+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/14.
//

import UIKit
extension UIViewController {
    static func returnColor(name: String) -> UIColor{
        switch name {
        case "lightBeige":
            return UIColor.MyColor.lightBeige
        case "green":
            return UIColor.MyColor.green
        case "lightOrange":
            return UIColor.MyColor.lightOrange
        case "lightBlue":
            return UIColor.MyColor.lightBlue
        case "lightWhite":
            return UIColor.MyColor.lightWhite
        case "lightPink":
            return UIColor.MyColor.lightPink
        case "yellow":
            return UIColor.MyColor.yellow
        case "red":
            return UIColor.MyColor.red
        default:
            return .white
        }
    }
}
