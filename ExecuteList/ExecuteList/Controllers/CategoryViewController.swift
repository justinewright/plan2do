//
//  CategoryViewController.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    var baseColour = K.colourCodes[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        styleNavBar(color: UIColor(hexString: baseColour))
    }
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        styleCell(cell, with: UIColor(hexString: K.colourCodes[indexPath.row % K.colourCodes.count]) )
        return cell
    }
    
    //MARK: - Data manipulation methods
    private func save(category: Category) {
        if category.name.isEmpty { return }
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func load() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete category
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add new category method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = createAlert()
        addNewCategoryAction(for: alert)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.placeholder = "Enter category name here"
        }
        
        return alert
    }
    
    private func addNewCategoryAction(for alert: UIAlertController) {
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = alert.textFields![0].text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
    }
    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.todoListSegueID, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedColor = indexPath.row % K.colourCodes.count
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }


}
