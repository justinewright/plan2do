//
//  ItemsViewController.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import UIKit

class ItemsViewController: UITableViewController {
    var todoItems: Array<Item>?
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID , for: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].name ?? "No Items added yet"

        return cell
    }
    
    //MARK: - Data manipulation methods
    
    private func load(){
        //load saved items
    }
    
    private func save(item: Item){
        if item.name.isEmpty { return }
        if todoItems == nil {
            todoItems = Array<Item>()
        }
        todoItems?.append(item)
        
        tableView.reloadData()
    }
    
    //MARK: - Add Item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        let alert = createAlert()
        addNewCategoryAction(for: alert)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.placeholder = "Enter item name here"
        }
        
        return alert
    }
    
    private func addNewCategoryAction(for alert: UIAlertController) {
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            var newItem = Item()
            newItem.name = alert.textFields![0].text!
            newItem.createdDate = Date()
            self.save(item: newItem)
        }
        alert.addAction(action)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
