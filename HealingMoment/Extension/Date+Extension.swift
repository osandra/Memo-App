//
//  Date+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/17.
//

import Foundation
extension Date {
    func toString(withFormat format: String = "yyyy년 MM월 dd일") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}
