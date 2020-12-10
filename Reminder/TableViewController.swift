//
//  TableViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit
import RealmSwift

//let realm = try! Realm()
//
//class StorageManager {
//
//    static func saveObj(task: Task){
//        try! realm.write {
//            realm.add(task)
//
//        }
//    }
//
//    static func deleteObj(task: Task){
//        try! realm.write {
//            realm.delete(task)
//        }
//    }
//
//}



class TableViewController: UITableViewController {
    
    //let realm = try! Realm()
    
    let notification =  Notifications()
    
    //var models = [MyReminder]()
    var taskList: Results<Task>!
    
    //=====
//    let realm = try! Realm()
    //var taskList1 = RealmSwift.List<Task>()
    //=====
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        taskList = realm.objects(Task.self)
        
        
//        var itemsData = realm.object(ofType: Items.self, forPrimaryKey: 0)
//        if itemsData == nil {
//            itemsData = try! realm.write { realm.create(Items.self, value: []) }
//        }
//        taskList1 = itemsData!.tasks
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if taskList.count > 0 {return taskList.count}else{
//            return 0
//        }
        //print("tasklist.count = ")
        //print(taskList1.count)
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //print(taskList[indexPath.row].task)
        cell.textLabel?.text = taskList[indexPath.row].task

        //cell.textLabel?.text = models[indexPath.row].title
        cell.textLabel?.textColor = .black
        
        let date = taskList[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        cell.detailTextLabel?.text = ""
        if let date = date{
            cell.detailTextLabel?.text = formatter.string(from: date)
        }
        
        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete{

            let task = taskList[indexPath.row]
            guard let id = task.identifier else{return}

            notification.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])

//            try! self.realm.write{
//                self.realm.delete(editingRow)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.reloadData()
//            }
            
            StorageManager.deleteObj(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)

            
            
            
            //models.remove(at: indexPath.row)
            

        }
    }

//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        //modelss
//        var mas = ["1","2","3"]
//        taskList.
//        mas.remove(at: sourceIndexPath.row)
//        let movedCell = taskList.remove(at: sourceIndexPath.row)
//        models.insert(movedCell, at: destinationIndexPath.row)
//        tableView.reloadData()
//
//    }
    
    // MARK: - Actions
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {return}
        
        
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.completion = { title, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
                
                
                let id = "id_\(title)"
                let new = MyReminder(title: title, date: date, identifier: id)
                
                let task = Task()//(value: [new.title, new.date, new.identifier])
                task.task = new.title
                task.date = new.date
                task.identifier = new.identifier
                
//                try! self.realm.write{
//                    self.realm.add(task)
//                }
                
                StorageManager.saveObj(task: task)
                
                
                
                //self.models.append(new)
                self.tableView.reloadData()
                
                if let date = date {
                    self.notification.scheduleNotification(title: title, indentifier: id, date: date)
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


struct MyReminder {
    let title: String
    let date: Date?
    let identifier: String
}
