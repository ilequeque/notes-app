import UIKit
import CoreData

class AddNewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var note: Note?
//    weak var delegate: AddNewControllerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteContent.delegate = self
        // Set the title text if available
        noteTitle.text = note?.title
        
        // If content is available, set it in the text view
        if let savedContent = note?.content {
            noteContent.text = savedContent
        } else {
            noteContent.text = "Enter your note content here..." // Optional placeholder
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = noteTitle.text, !title.isEmpty else {
            showAlert(with: "Title Required", message: "Please enter a title for your note.")
            return
        }
        
        guard let content = noteContent.text, !content.isEmpty else {
            showAlert(with: "Content Required", message: "Please enter some content for your note.")
            return
        }
        
        note?.title = title
        note?.content = content
        // Update the existing note's content if it exists, or create a new note if it doesn't
        if let existingNote = fetchNoteWithTitle(title) {
            existingNote.content = content
        } else {
            saveNote(title: title, content: content)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func fetchNoteWithTitle(_ title: String) -> Note? {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let notes = try context.fetch(fetchRequest)
            return notes.first
        } catch {
            print("Error fetching note: \(error)")
            return nil
        }
    }
    
    func saveNote(title: String, content: String) {
        let newNote = Note(context: context)
        newNote.title = title
        newNote.content = content
        do {
            try context.save()
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension AddNewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "Enter your note content here..." {
      textView.text = "" // Clear placeholder text on tap
      textView.textColor = .black // Optional: Set default text color
    }
  }
}
