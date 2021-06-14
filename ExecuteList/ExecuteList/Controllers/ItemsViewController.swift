//
//  ItemsViewController.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import UIKit
import RealmSwift

class ItemsViewController: SwipeViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    var selectedColor: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        styleNavBar(color: K.navColours[selectedColor ?? 0]!)
        searchBar.barTintColor = K.navColours[selectedColor ?? 0]
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].name ?? "No Items added yet"
        if let item = todoItems?[indexPath.row]{
            let color = ((item.done ? UIColor(hexString: K.colourCodes[selectedColor ?? 0]) : UIColor.lightGray)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(3*todoItems!.count)) ))!
            styleCell(cell, with: color )
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete category
    override func updateModel(at indexPath: IndexPath) {
        if let  itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    //MARK: - Data manipulation methods
    
    private func save(item: Item) {
        if item.name.isEmpty { return }
        guard let currentCategory = selectedCategory else {return}
        do {
            try realm.write {
                currentCategory.items.append(item)
            }
        } catch {
            print("Error saving item, \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func load() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        
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
            let newItem = Item()
            newItem.name = alert.textFields![0].text!
            newItem.createdDate = Date()
            self.save(item: newItem)
        }
        alert.addAction(action)
    }
}

extension ItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
