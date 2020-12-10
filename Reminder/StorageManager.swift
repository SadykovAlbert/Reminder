//
//  StorageManager.swift
//  Reminder
//
//  Created by Albert on 10.12.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {

    static func saveObj(task: Task){
        try! realm.write {
            realm.add(task)
        }
    }

    static func deleteObj(task: Task){
        try! realm.write {
            realm.delete(task)
        }
    }

}
