//
//  ViewController.swift
//  ToDo
//
//  Created by Zofia Drabek on 25/06/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {

    var toDoes: [ToDo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var toDoTableView: UITableView!
    let colors: [String: UIColor] = ["Work": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Groceries": #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), "Other": #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)]
    @IBOutlet var lackOfTasksLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        tableViewSet()
        
        fetchData()
        
    }
    
    func tableViewSet() {
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDo")
        toDoTableView.tableFooterView = UIView()
    }
    
    func fetchData() {
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.sortDescriptors = [.init(keyPath: \ToDo.date, ascending: true)]
        request.returnsObjectsAsFaults = false
        do {
            toDoes = try context.fetch(request)
        } catch {
            print("Failed")
        }
        
        if toDoes.count == 0 {
            lackOfTasksLabel.isHidden = false
        } else {
            lackOfTasksLabel.isHidden = true
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        fetchData()
        toDoTableView.reloadData()
    }
    
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo", for: indexPath) as! ToDoTableViewCell
        cell.nameLabel.text = toDoes[indexPath.row].name
        cell.categoryLabel.text = toDoes[indexPath.row].category
        let color = colors[toDoes[indexPath.row].category!]
        cell.backgroundColor = color
        if let date = toDoes[indexPath.row].date {
            cell.dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Do you wanna delete \(toDoes[indexPath.row].name ?? "this todo")?", message: "", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "delete", style: .destructive) { (action) in
                let toDoey = self.toDoes[indexPath.row]
                let context = self.appDelegate.persistentContainer.viewContext
                context.delete(toDoey)
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
}
