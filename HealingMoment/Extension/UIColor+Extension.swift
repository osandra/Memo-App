//
//  UIColor+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/10.
//

import UIKit
extension UIColor {
  struct MyColor {
    static var lightBeige: UIColor  { return UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00) }
    static var lightGreen: UIColor  { return UIColor(red: 0.83, green: 0.89, blue: 0.83, alpha: 1.00) }
    static var lightOrange: UIColor {return UIColor(red: 0.93, green: 0.70, blue: 0.56, alpha: 1.00) }
    static var lightBlue: UIColor {return UIColor(red: 0.83, green: 0.88, blue: 0.92, alpha: 1.00) }
    static var coral: UIColor { return UIColor(red: 0.87, green: 0.47, blue: 0.38, alpha: 1.00) }
    static var lightWhite: UIColor {return UIColor(red: 0.97, green: 0.95, blue: 0.95, alpha: 1.00)}
    static var lightPink: UIColor {return UIColor(red: 0.98, green: 0.83, blue: 0.78, alpha: 1.00)}
    static var green: UIColor {return UIColor(red: 0.09, green: 0.78, blue: 0.60, alpha: 1.00)}
    static var yellow: UIColor {return UIColor(red: 1.00, green: 0.79, blue: 0.34, alpha: 1.00)}
    static var lightGray: UIColor {return UIColor(red: 0.81, green: 0.84, blue: 0.88, alpha: 1.00) }
    static var red: UIColor{return UIColor(red: 0.93, green: 0.32, blue: 0.33, alpha: 1.00)}

    static var colorArray = [ UIColor.MyColor.lightBeige, UIColor.MyColor.lightOrange, UIColor.MyColor.lightBlue,UIColor.MyColor.lightWhite,UIColor.MyColor.lightPink, UIColor.MyColor.green, UIColor.MyColor.yellow, UIColor.MyColor.red]
  }
}
