//
//  ViewController.swift
//  Todoey
//
//  Created by Aneesh Prabu on 09/06/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //MARK: - Initialize variables here
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
    
        
        return cell
    }
    
    
    //MARK: - Tableview number of Rows method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    
    //MARK: - TableView Delegate Methods (ie) What happens when we select a row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    //.done in item array = opposite of .done in the same item array
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items (ie) That plus button +
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
//                    //Changing title color of alert box :
//                    let attributedString = NSAttributedString(string: "Title", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white])
//                    alert.setValue(attributedString, forKey: "attributedTitle")
//                    // Accessing alert view backgroundColor :
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
//                    // Accessing buttons tintcolor :
//                    alert.view.tintColor = UIColor.white
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.keyboardAppearance = .dark
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
    }
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search bar methods


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            loadItems()
            
            //Here we ask the main thread to use a async method which releaves us from being the first responder when cancel button is clicked on the search bar
            
            DispatchQueue.main.async { //Thread manager (Assume the person who distributes our tasks to various threads based on priority)
                searchBar.resignFirstResponder() //dismiss keyboard (no longer have the cursor and keyboard)
            }
        }
    }
}

