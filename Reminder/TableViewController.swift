//
//  TableViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit
import RealmSwift

class TaskList: Object{
    @objc dynamic var task = ""
    @objc dynamic var date: Date? = nil
    @objc dynamic var identifier: String? = nil
}



class TableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let notification =  Notifications()
    
    //var models = [MyReminder]()
    var modelss: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        modelss = realm.objects(TaskList.self)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if modelss.count > 0 {return modelss.count}else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = modelss[indexPath.row].task

        //cell.textLabel?.text = models[indexPath.row].title
        cell.textLabel?.textColor = .black
        
        let date = modelss[indexPath.row].date
        
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

            let editingRow = modelss[indexPath.row]
            guard let id = editingRow.identifier else{return}

            notification.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])

            try! self.realm.write{
                self.realm.delete(editingRow)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
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
//        let movedCell = models.remove(at: sourceIndexPath.row)
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
                
                let task = TaskList()//(value: [new.title, new.date, new.identifier])
                task.task = new.title
                task.date = new.date
                task.identifier = new.identifier
                
                try! self.realm.write{
                    self.realm.add(task)
                }
                
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
