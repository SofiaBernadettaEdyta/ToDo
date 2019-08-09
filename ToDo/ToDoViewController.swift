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
    @IBOutlet var tableView: UITableView!
    let colors: [String: UIColor] = ["Work": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Groceries": #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), "Other": #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)]
    @IBOutlet var lackOfTasksLabel: UILabel!
    let cellIdentifier = "ToDo"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        fetchData()
        tableViewSet()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let context = self.appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            // 
        }
    }
    
    func tableViewSet() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
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
        tableView.reloadData()
    }
    
    func displayAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Do you wanna delete \(toDoes[indexPath.row].name ?? "this todo")?", message: "", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "delete", style: .destructive) { (action) in
            let toDoey = self.toDoes[indexPath.row]
            let context = self.appDelegate.persistentContainer.viewContext
            context.delete(toDoey)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let navController = segue.destination as! UINavigationController
            let targetController = navController.topViewController as! DetailTableViewController
            let row = (sender as! IndexPath).row
            targetController.toDoey = toDoes[row]
        }
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ToDoTableViewCell
        cell.nameLabel.text = toDoes[indexPath.row].name
        cell.categoryLabel.text = toDoes[indexPath.row].category
        cell.toggleDone = { [weak self] in
            self?.toDoes[indexPath.row].isDone.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let imageName = toDoes[indexPath.row].isDone ? "done" : "notDone"
        cell.doneButton.setImage(UIImage(named: imageName), for: .normal) 
        let color = colors[toDoes[indexPath.row].category!]
        cell.backgroundColor = color
        if let date = toDoes[indexPath.row].date {
            cell.dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayAlert(for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    
}
