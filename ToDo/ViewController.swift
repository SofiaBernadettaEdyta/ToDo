//
//  ViewController.swift
//  ToDo
//
//  Created by Zofia Drabek on 25/06/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var toDoes: [ToDo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var toDoTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        request.returnsObjectsAsFaults = false
        do {
            toDoes = try context.fetch(request) as! [ToDo]
        } catch {
            print("Failed")
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        request.returnsObjectsAsFaults = false
        do {
            toDoes = try context.fetch(request) as! [ToDo]
        } catch {
            print("Failed")
        }
        
        toDoTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo", for: indexPath)
        cell.textLabel?.text = toDoes[indexPath.row].name
        cell.detailTextLabel?.text = toDoes[indexPath.row].category
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDoey = toDoes[indexPath.row]
            let context = appDelegate.persistentContainer.viewContext
            context.delete(toDoey)
    
            tableView.reloadData()
            
        }
    }
    
    
}
