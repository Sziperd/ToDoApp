//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by Patryk Piwowarczyk on 23/02/2022.
//

import UIKit
import SwipeCellKit
import CoreData
class CategoryTableViewController: UITableViewController{
    var itemArray2 = [Categoryy]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()

loadItems()
  
        tableView.rowHeight = 80.0

}
    
    //MARK: TableView datasource methods
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
// #warning Incomplete implementation, return the number of sections
return 1
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray2.count
    }
    
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
// }
//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        //cell.textLabel?.text = itemArray2[indexPath.row].name
       
        let item = itemArray2[indexPath.row]
        cell.textLabel?.text = item.name
        
        cell.textLabel?.text = itemArray2[indexPath.row].name
        cell.delegate = self
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexpath: IndexPath){
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! ToDoListViewController
         
         if let indexPath = tableView.indexPathForSelectedRow {
             destinationVC.selectedCategory = itemArray2[indexPath.row]
         }
     }
    
    //MARK: Add new categories
           
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new category to the list", message: "", preferredStyle: .alert)
        
      
      
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            let newItem = Categoryy(context: self.context)
            newItem.name = textField.text!
          
            self.itemArray2.append(newItem)
            
            
            self.saveItems()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input your category"
            textField = alertTextField
           // print(alertTextField.text)
   
    }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
   
    
  
    //MARK: Data manipulation methods
    
    
        func saveItems() {
             
          
              do{
                  
                 try context.save()
              }catch {
               print("error \(error)")
              }
              self.tableView.reloadData()
        }
        
        
        
        
        func loadItems(with request: NSFetchRequest<Categoryy> = Categoryy.fetchRequest()) {
         
          // let request : NSFetchRequest<Item> = Item.fetchRequest()
           do{
         itemArray2 =  try context.fetch(request)
           }catch {
               
               print("Error\(error)")
           }
            tableView.reloadData()
         
         
       }
    
}



extension CategoryTableViewController: SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.saveItems()
            self.context.delete(self.itemArray2[indexPath.row])
            self.itemArray2.remove(at: indexPath.row)
            tableView.reloadData()
      }

          
            
        

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    
}
