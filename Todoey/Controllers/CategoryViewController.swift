//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Marisha Deroubaix on 13/07/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
  
  let realm = try! Realm()

  var categoryArray: Results<Category>?

  
  override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCategory()
    tableView.separatorStyle = .none

    }


  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      let newCategory = Category()
      newCategory.name = textField.text!
      newCategory.colour = UIColor.randomFlat.hexValue()
      
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
  
  //MARK: - Delete Data From Swipe
  
  override func updateModel(at indexPath: IndexPath) {
    if let categotyForDeletion = self.categoryArray?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(categotyForDeletion)
        }
      } catch {
        print("Error deleting category, \(error)")
      }
    }
  }
  
  // MARK: - Table view data source
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryArray?.count ?? 1
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let category = categoryArray?[indexPath.row] {

    cell.textLabel?.text = category.name
    guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
    
    cell.backgroundColor = categoryColour
    cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
      
    }
    
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



