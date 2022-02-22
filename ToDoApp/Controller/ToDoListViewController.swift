//


import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
            itemArray = items
        }*/
        // Do any additional setup after loading the view.
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "item1"
        itemArray.append(newItem)
        
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
      
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     
        
  
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
        let newItem = Item()
        newItem.title = textField.text!
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textField.text)
            self.itemArray.append(newItem)
            
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input your item"
            textField = alertTextField
            print(alertTextField.text)
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}



