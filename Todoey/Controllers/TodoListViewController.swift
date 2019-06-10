//
//  ViewController.swift
//  Todoey
//
//  Created by Aneesh Prabu on 09/06/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //MARK - Initialize variables here
    var itemArray = [Item] ()
    let defaults = UserDefaults.standard
    
    
    //MARK - ViewDidLoad Method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {

            itemArray = items

        }
        
        let newItem1 = Item()
        newItem1.title = "Buy Eggos"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy more Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy more and more Eggos"
        itemArray.append(newItem3)
        
        
    }
    
    //MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - Tableview number of Rows method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    //MARK - TableView Delegate Methods (ie) What happens when we select a row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //.done in item array = opposite of .done in the same item array
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items (ie) That plus button +
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
                    //Changing title color of alert box :
                    let attributedString = NSAttributedString(string: "Title", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white])
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    // Accessing alert view backgroundColor :
                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
                    // Accessing buttons tintcolor :
                    alert.view.tintColor = UIColor.white
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            //What will happen once the user clicks the add item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
    

}

