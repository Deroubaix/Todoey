//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Marisha Deroubaix on 13/07/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  var categoryArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }


  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      
      self.categoryArray.append(newCategory)
      self.saveCategory()
    }
      alert.addAction(action)
    
      alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    present(alert, animated: true, completion: nil)

  }
  
  func saveCategory() {
    do {
      try context.save()
    } catch {
      print("Error saving category \(error)")
    }
    self.tableView.reloadData()
  }
  
  func loadCategory(request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categoryArray = try context.fetch(request)
    } catch {
      print("Error fetching data from category \(error)")
    }
    tableView.reloadData()
  }

  
  // MARK: - Table view data source
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoryArray[indexPath.row].name
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
    
    tableView.reloadData()
    saveCategory()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
  }
  
}
