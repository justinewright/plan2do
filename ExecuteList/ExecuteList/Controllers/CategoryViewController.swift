//
//  CategoryViewController.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var categories: Array<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID , for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"

        return cell
    }
    //MARK: - Data manipulation methods
    private func save(category: Category){
        if category.name.isEmpty { return }
        if categories == nil {
            categories = Array<Category>()
        }
        categories?.append(category)
        print(category.name)
        print(categories?.count)
        tableView.reloadData()
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
            let newCategory = Category(
                name: alert.textFields![0].text! ,
                items: [])
            self.save(category: newCategory)
        }
        alert.addAction(action)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
