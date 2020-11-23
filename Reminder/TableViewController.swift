//
//  TableViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let notification =  Notifications()
   
    var models = [MyReminder]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem

//        self.tableView.estimatedRowHeight = 80
//        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row].title
        cell.textLabel?.textColor = .black
        
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"//"yyyy-MM-dd HH:mm"//"MMM, dd, YYYY"
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
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let cell = tableView.cellForRow(at: indexPath)
    //        cell?.textLabel?.textColor = .red
    //
    //        let notificationType = models[indexPath.row]
    //
    //        let alert = UIAlertController(title: notificationType,
    //                                      message: "After 5 seconds " + notificationType + " will appear",
    //                                      preferredStyle: .alert)
    //
    //        let okAction = UIAlertAction(title: "OK", style: .default){ (action) in
    //
    //            self.notification.scheduleNotification(notificationType: notificationType)
    //        }
    //
    //        alert.addAction(okAction)
    //        present(alert, animated: true, completion: nil)
    //    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath)
        //cell?.textLabel?.textColor = .blue
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            
            let id = models[indexPath.row].identifier
             
            print(models[indexPath.row])
             notification.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
             print(id)
            
            
            
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            

        }
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedCell = models.remove(at: sourceIndexPath.row)
        models.insert(movedCell, at: destinationIndexPath.row)
        tableView.reloadData()
        
    }
    
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
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
                self.models.append(new)
                self.tableView.reloadData()
                
                if let date = date {
                 self.notification.scheduleNotification(title: title, indentifier: id, date: date)
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    @IBAction func unwind( _ seg: UIStoryboardSegue) {
//    }
    
}


struct MyReminder {
    let title: String
    let date: Date?
    let identifier: String
}
