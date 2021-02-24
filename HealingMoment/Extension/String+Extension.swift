//
//  String+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/17.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy년 MM월 dd일")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date

    }
}
