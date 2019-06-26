//
//  TableViewController.swift
//  ToDo
//
//  Created by Zofia Drabek on 25/06/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//

import UIKit
import CoreData

class AddTableViewController: UITableViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    let categories = Category.allCases
    
    private var categoryPicker: UIPickerView?
    private var datePicker: UIDatePicker?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        datePickerViewSetUp()
        
        addTapGesture()
        
        categoryPickerViewSetUp()
        
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    func datePickerViewSetUp() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.addTarget(self, action: #selector(dateTextFieldBeganEditing), for: .editingDidBegin)
    }
    
    func categoryPickerViewSetUp() {
        categoryPicker = UIPickerView()
        categoryPicker?.delegate = self
        categoryPicker?.dataSource = self
        categoryPicker?.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.inputView = categoryPicker
        categoryTextField.addTarget(self, action: #selector(categoryTextFieldBeganEditing), for: .editingDidBegin)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row].rawValue.capitalized
    }
    
    @objc func dateTextFieldBeganEditing() {
        guard let datePicker = datePicker else { return }
        date = datePicker.date
        dateTextField.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        date = datePicker.date
        dateTextField.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        view.endEditing(true)
        if let name = nameTextField.text, let date = date, let category = categoryTextField.text {
            saveData(name: name, date: date, category: category)
        } else {
            displayAlert(title: "Try again!", message: "You didn't fill everything!", actionTitle: "Try")
        }
    }
    
    func saveData(name: String, date: Date, category: String) {
        let context = self.appDelegate.persistentContainer.viewContext
        let entity = ToDo(context: context)
        entity.name = name
        entity.date = date
        entity.category = category
        
        do {
            try context.save()
            displayAlert(title: "SAVED!", message: "we saved your data", actionTitle: "OK!")
        } catch {
            displayAlert(title: "Something went wrongly", message: "we couldn't save your data", actionTitle: "Try again!")
        }
    }
    
    func displayAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func categoryTextFieldBeganEditing() {
        guard let categoryPicker = categoryPicker else { return }
        let category = categories[categoryPicker.selectedRow(inComponent: 0)]
        categoryTextField.text = category.rawValue.capitalized
    }
    
    
}

extension AddTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
