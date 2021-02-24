//
//  Record.swift
//  healingMoments
//
//  Created by heawon on 2021/02/10.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var imageData: Data?
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var healingRating: Int = 0
    @objc dynamic var date: Date = Date()
    override static func primaryKey() -> String? {
        return "_id"
    }
    let parentCategory = LinkingObjects(fromType: Category.self, property: "records")
}
