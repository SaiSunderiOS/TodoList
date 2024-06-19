import UIKit

class TodoListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let todoViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the TaskCell
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoViewModel.fetchTasks { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch tasks: \(error)")
            }
        }
    }
    

    @IBAction func addBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else { return UITableViewCell()}
        let task = todoViewModel.tasks[indexPath.row]
        cell.todoTextLbl?.text = task.todo
        if task.completed {
            cell.doneTaskSetupView()
        }else{
            cell.inCompleteTaskSetupView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        vc.isFromEdit = true
        vc.index = todoViewModel.tasks[indexPath.row]
        vc.todoViewModel = self.todoViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = todoViewModel.tasks[indexPath.row]
            todoViewModel.deleteTask(task: task) { [weak self] result in
                switch result {
                case .success:
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("Failed to delete task: \(error)")
                }
            }
        }
    }
}
