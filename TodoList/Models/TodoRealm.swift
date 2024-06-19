import RealmSwift
import Foundation

struct TodoResponse: Decodable {
    let todos: [TodoRealm]
}

class TodoRealm: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var todo: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var userId: Int = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    private enum CodingKeys: String, CodingKey {
        case id, todo, completed, userId
    }
}
