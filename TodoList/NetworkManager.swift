import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchTasks(completion: @escaping (Result<[TodoRealm], Error>) -> Void) {
        AF.request("https://dummyjson.com/todos").responseDecodable(of: TodoResponse.self) { response in
            switch response.result {
            case .success(let todoResponse):
                completion(.success(todoResponse.todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addTask(todo: String, completed: Bool, userId: Int = 5, completion: @escaping (Result<TodoRealm, Error>) -> Void) {
        let parameters: [String: Any] = [
            "todo": todo,
            "completed": completed,
            "userId": userId
        ]
        
        AF.request("https://dummyjson.com/todos/add", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: TodoRealm.self) { response in
            switch response.result {
            case .success(let task):
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateTask(taskId: Int, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = [
            "completed": completed
        ]
        
        AF.request("https://dummyjson.com/todos/\(taskId)", method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func deleteTask(taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request("https://dummyjson.com/todos/\(taskId)", method: .delete).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
