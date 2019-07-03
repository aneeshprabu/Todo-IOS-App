//
//  ViewController.swift
//  Todoey
//
//  Created by Aneesh Prabu on 09/06/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //MARK: - Initialize variables here
    var itemArray = [Item] ()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
//Singleton class which we use from the AppDelegate to get the context of the table
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//
//            itemArray = items
//
//        }
    }
    
    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - Tableview number of Rows method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    //MARK: - TableView Delegate Methods (ie) What happens when we select a row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //.done in item array = opposite of .done in the same item array
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
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
            
            //What will happen once the user clicks the add item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
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
    
    
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error in saving context")
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems( with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
                
        do {
            itemArray =  try context.fetch(request)
        }
        catch {
            print("Problem loading the data : \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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

