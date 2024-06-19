import RealmSwift

class TodoViewModel {
    private let realm = try! Realm()
    
    var tasks: Results<TodoRealm> {
        return realm.objects(TodoRealm.self)
    }

    func fetchTasks(completion: @escaping (Result<[TodoRealm], Error>) -> Void) {
        NetworkManager.shared.fetchTasks { result in
            switch result {
            case .success(let tasks):
                try! self.realm.write {
                    self.realm.add(tasks, update: .all)
                }
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addTask(todo: String, completed: Bool, userId: Int = 5, completion: @escaping (Result<TodoRealm, Error>) -> Void) {
        NetworkManager.shared.addTask(todo: todo, completed: completed, userId: userId) { result in
            switch result {
            case .success(let task):
                let task = TodoRealm()
                if let maxId = self.tasks.max(ofProperty: "id") as Int? {
                           task.id = maxId + 1
                       } else {
                           task.id = 1
                       }
                       task.todo = todo
                       task.completed = completed

                try! self.realm.write {
                    self.realm.add(task)
                       }
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateTask(task: TodoRealm, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.updateTask(taskId: task.id, completed: completed) { result in
            switch result {
            case .success:
                try! self.realm.write {
                    task.completed = completed
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteTask(task: TodoRealm, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.deleteTask(taskId: task.id) { result in
            switch result {
            case .success:
                try! self.realm.write {
                    self.realm.delete(task)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
