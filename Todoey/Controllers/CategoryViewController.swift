//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Marisha Deroubaix on 13/07/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  
  let realm = try! Realm()

  var categoryArray: Results<Category>?

  
  override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }


  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      let newCategory = Category()
      newCategory.name = textField.text!
      
      self.save(category: newCategory)
    }
      alert.addAction(action)
    
      alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    present(alert, animated: true, completion: nil)

  }
  
  func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving category \(error)")
    }
    self.tableView.reloadData()
  }
  
  func loadCategory() {
    
    categoryArray = realm.objects(Category.self)

    tableView.reloadData()
  }

  
  // MARK: - Table view data source
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryArray?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
    
    tableView.reloadData()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray?[indexPath.row]
    }
  }
  
}
