//
//  TaskModel.swift
//  Reminder
//
//  Created by Albert on 10.12.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import Foundation
import RealmSwift


class Task: Object{
    @objc dynamic var task = ""
    @objc dynamic var date: Date? = nil
    @objc dynamic var identifier: String? = nil
}
//
//class Items: Object {
//    @objc dynamic var id: Int = 0
//    let tasks = List<Task>()
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//class Task: Object {
//    @objc dynamic var id: String = UUID().uuidString
//    @objc dynamic var task = ""
//    @objc dynamic var date: Date? = nil
//    @objc dynamic var identifier: String? = nil
//}
