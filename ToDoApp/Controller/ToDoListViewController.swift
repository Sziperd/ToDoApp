//


import UIKit
import CoreData
class ToDoListViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var UISearchbar: UISearchBar!
    
    
    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 

    var selectedCategory : Categoryy? {
          didSet{
              loadItems()
          }
      }
    
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
     //  loadItems()
    
    
    
    
    //MARK: Tableview datasource methods
    
    
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
    
    
    //MARK: TableView Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
   
        
  saveItems()
        
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //MARK: Add new Items
        
    }
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
      
      
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input your item"
            textField = alertTextField
           // print(alertTextField.text)
        }
        
      
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Model manipulation methods
    
    
    func saveItems() {
        
      
          do{
              
             try context.save()
          }catch {
           print("error \(error)")
          }
          self.tableView.reloadData()
    }
    
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
         
         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
         
         if let addtionalPredicate = predicate {
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
         } else {
             request.predicate = categoryPredicate
         }

         
         do {
             itemArray = try context.fetch(request)
         } catch {
             print("Error fetching data from context \(error)")
         }
         
         tableView.reloadData()
         
     }
     
 
    
    /*
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
     
      // let request : NSFetchRequest<Item> = Item.fetchRequest()
       do{
     itemArray =  try context.fetch(request)
       }catch {
           
           print("Error\(error)")
       }
        tableView.reloadData()
     
     
   }
    */
    //MARK: search bar functionality.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
       // let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
       // request.sortDescriptors = [sortDescriptr]
        
        
        loadItems(with: request)
        
     //   do{
      //      itemArray = try context.fetch(request)
      //      }catch{
      //      print("error\(error)")
      //  }
        //tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0{
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            

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





