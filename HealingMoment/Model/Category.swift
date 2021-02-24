//
//  Category.swift
//  healingMoments
//
//  Created by heawon on 2021/02/10.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var colorHex : String = ""
    @objc dynamic var name: String = ""
    override static func primaryKey() -> String? {
          return "_id"
    }
    @objc dynamic var date: Date = Date()
    let records = List<Record>()
}
