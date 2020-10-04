import Foundation
import RealmSwift

class Item_ : Object {
    @objc dynamic var issue : String = "";
    @objc dynamic var isDone: Bool = false;
    @objc dynamic var isImportant: Bool = false;
    @objc dynamic var ownerList: String?
}
