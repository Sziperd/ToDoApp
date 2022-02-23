//


import UIKit
import CoreData
class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
       loadItems()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       
        //itemArray[indexPath.row].setValue("completed", forKey: "title")
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
      
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
   
        
  saveItems()
        
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
      
      
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input your item"
            textField = alertTextField
            print(alertTextField.text)
        }
        
      
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
      
          do{
              
             try context.save()
          }catch {
           print("error \(error)")
          }
          self.tableView.reloadData()
    }
   func loadItems() {
     
       let request : NSFetchRequest<Item> = Item.fetchRequest()
       do{
     itemArray =  try context.fetch(request)
       }catch {
           
           print("Error\(error)")
       }
      
     
     
   }
}
    /*
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
          do{
               let data = try encoder.encode(self.itemArray)
              try data.write(to: self.dataFilePath!)
          }catch {
              print("error, \(error)")
          }
          self.tableView.reloadData()
    }
    func loadItems() {
        
        
      
        if let data = try?  Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("error, \(error)")
            }
            
        }
        
    }
     
     */





