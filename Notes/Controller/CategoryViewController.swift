//
//  NoteViewController.swift
//  Notes
//
//  Created by Iliyas Shakhabdin on 16.04.2024.
//

import Foundation
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var notes = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //        guard let vc = storyboard?.instantiateViewController(identifier: "goToAddition") as! AddNewController as AddNewController{
        //            return
        //        }
        //        navigationController?.pushViewController(vc, animated: true)
        //        vc.title = "New Note"
        
        performSegue(withIdentifier: "goToAddition", sender: self)
        //        var textField = UITextField()
        //
        //        let alert = UIAlertController(title: "Add new note", message: "", preferredStyle: .alert)
        //
        //        let action = UIAlertAction(title: "Add note", style: .default) { action in
        //            let newCategory = Note(context: self.context)
        //            newCategory.title = textField.text!
        //
        //            self.noteCategoryArray.append(newCategory)
        //            self.saveCategories()
        //        }
        //
        //        alert.addTextField { field in
        //            textField = field
        //            textField.placeholder = "Create a new note"
        ////            print(alertTextField.text)
        //        }
        //
        //        alert.addAction(action)
        //
        //        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let category = notes[indexPath.row]
        cell.textLabel?.text = category.title
        
        return cell
    }
    
    // MARK: - table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAddition", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddNewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.note = notes[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteNote(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    // MARK: - data manipulation methods
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error loading data: \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = notes[indexPath.row]
        context.delete(noteToDelete)
        
        do {
            try context.save()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Error deleting note: \(error)")
        }
    }
}
