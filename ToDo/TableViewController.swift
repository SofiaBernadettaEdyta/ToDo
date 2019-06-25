//
//  TableViewController.swift
//  ToDo
//
//  Created by Zofia Drabek on 25/06/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var addTableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    let categories = Category.allCases
    
    private var categoryPicker: UIPickerView?
    private var datePicker: UIDatePicker?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var date: Date!
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView.tableFooterView = UIView()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        dateTextField.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        categoryPicker = UIPickerView()
        categoryPicker?.delegate = self
        categoryPicker?.dataSource = self
        categoryPicker?.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.inputView = categoryPicker
        

        
        
    }

    @objc func viewTapped() {
        
        view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
        categoryTextField.text = category.rawValue.capitalized
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        date = datePicker.date
        dateTextField.text = dateFormatter.string(from: date)
       
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            
            let context = self.appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)
            let newToDoey = NSManagedObject(entity: entity!, insertInto: context)
            newToDoey.setValue(self.nameTextField.text, forKey: "name")
            newToDoey.setValue(self.date, forKey: "date")
            newToDoey.setValue(self.category.rawValue.capitalized, forKey: "category")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    //prepare for dismiss
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue.capitalized
    }
    
}
