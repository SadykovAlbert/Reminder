//
//  TableViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    let notification =  Notifications()
    let realm = try! Realm()
    var taskList1 = RealmSwift.List<Task>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
                
        var itemsData = realm.object(ofType: Items.self, forPrimaryKey: 0)
        if itemsData == nil {
            itemsData = try! realm.write { realm.create(Items.self, value: []) }
        }
        
        taskList1 = itemsData!.tasks
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.textLabel?.text = taskList1[indexPath.row].task
        cell.textLabel?.textColor = .black
        
        let date = taskList1[indexPath.row].date
        
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

            let task = taskList1[indexPath.row]
            guard let id = task.identifier else{return}

            notification.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])

            try! realm.write {
                taskList1.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        try! taskList1.realm?.write {
            taskList1.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }

        tableView.reloadData()

    }
    
    // MARK: - Actions
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {return}
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.completion = { title, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
                let identifier = UUID().uuidString
                
                let task = Task()
                task.task = title
                task.date = date
                task.identifier = identifier
                
                try! self.realm.write {
                    self.taskList1.append(task)
                }
                
                self.tableView.reloadData()
                
                if let date = date {
                    self.notification.scheduleNotification(title: title, indentifier: identifier, date: date)
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
