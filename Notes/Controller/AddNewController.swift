import UIKit
import RealmSwift

class AddNewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    let realm = try! Realm()
    var note: Note?
    //    weak var delegate: AddNewControllerDelegate?
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteContent.delegate = self
        // Set the title text if available
        noteTitle.delegate = self
        noteTitle.text = note?.title ?? "Enter your note title here..."
        noteContent.text = note?.content ?? "Enter your note content here..."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(.yellow)
        guard let navBar = self.navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist.")}
        navBar.tintColor = UIColor(.black)
        noteTitle.borderStyle = .none
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
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
        
        saveNote(title: title, content: content)
        
        navigationController?.popViewController(animated: true)
    }
    
    func saveNote(title: String, content: String) {
        try! realm.write {
            if let existingNote = realm.objects(Note.self).filter("title == %@", title).first {
                existingNote.content = content
            } else {
                let newNote = Note()
                newNote.title = title
                newNote.content = content
                newNote.dateCreated = Date()
                realm.add(newNote)
            }
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

extension AddNewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Enter your note title here..." {
//            textField.placeholder = ""
            textField.text = ""
            textField.textColor = .black
        }
    }
}
