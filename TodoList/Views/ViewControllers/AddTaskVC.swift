import UIKit

class AddTaskVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var viewForTextView: UIView!
    @IBOutlet weak var textView : UITextView!
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    @IBOutlet weak var saveBtn : UIButton!
    @IBOutlet weak var deleteBtn : UIButton!
    @IBOutlet weak var titleLbl : UILabel!
    
    var isFromEdit = false
    var index : TodoRealm?
    let placeholder = "Enter your text here..."
    let placeholderColor = UIColor.lightGray
    var todoViewModel = TodoViewModel()
    var segmentSelectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewForTextView.layer.cornerRadius = 20
        viewForTextView.layer.borderWidth = 1
        viewForTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        textView.text = placeholder
        textView.textColor = placeholderColor
        textView.delegate = self
        
        // Initial update for segment colors
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        saveBtn.layer.cornerRadius = 20
        deleteBtn.layer.cornerRadius = 20
        
        segmentSelectedIndex = 0
        
        if isFromEdit {
            saveBtn.isHidden = false
            deleteBtn.isHidden = false
            titleLbl.text = "Edit Task"
            setupView()
        } else {
            titleLbl.text = "Add Task"
            deleteBtn.isHidden = true
            saveBtn.isHidden = false
        }
        updateSegmentedControlTintColor()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }

    func setupView() {
        guard let index = index else { return }
        textView.text = index.todo
        textView.textColor = .black
        segmentSelectedIndex = index.completed ? 1 : 0
        segmentedControl.selectedSegmentIndex = segmentSelectedIndex
        updateSegmentedControlTintColor()
    }

    func updateSegmentedControlTintColor() {
        if segmentSelectedIndex == 1 {
            segmentedControl.selectedSegmentTintColor = UIColor.systemGreen
        } else {
            segmentedControl.selectedSegmentTintColor = UIColor.systemRed
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        segmentSelectedIndex = sender.selectedSegmentIndex
        updateSegmentedControlTintColor()
    }

    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let taskText = textView.text, !taskText.isEmpty, taskText != placeholder else { return }
        if isFromEdit, let task = index {
            todoViewModel.updateTask(task: task, completed: segmentSelectedIndex == 1) { [weak self] result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Failed to update task: \(error)")
                }
            }
        } else {
            todoViewModel.addTask(todo: taskText, completed: segmentSelectedIndex == 1) { [weak self] result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Failed to add task: \(error)")
                }
            }
        }
    }

    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        if let task = index {
            todoViewModel.deleteTask(task: task) { [weak self] result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Failed to delete task: \(error)")
                }
            }
        }
    }
}
