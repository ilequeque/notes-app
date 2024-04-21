//
//  NoteViewController.swift
//  Notes
//
//  Created by Iliyas Shakhabdin on 16.04.2024.
//

import Foundation
import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var notes: Results<Note>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(.yellow)
        guard let navBar = self.navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist.")}
        navBar.tintColor = UIColor(.black)
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddition", sender: self)
    }
    
    // MARK: - Table view data methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = notes?[indexPath.row].title ?? "No notes added yet"
        
        return cell
    }
    
    // MARK: - table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAddition", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddNewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.note = notes?[indexPath.row]
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
    func loadNotes() {
        notes = realm.objects(Note.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func deleteNote(at indexPath: IndexPath) {
        if let noteForDeletion = notes?[indexPath.row]
        {
            do {
                try realm.write {
                    realm.delete(noteForDeletion)
                    tableView.reloadData()
                }
            } catch{
                print("Error deleting data, \(error)")
            }
        }
    }
}
