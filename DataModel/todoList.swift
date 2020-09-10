import Foundation
import RealmSwift

class todoList: Object {
    @objc dynamic var title:String = "";
    let items = List<Item_>()
    var appendix = LinkingObjects(fromType: listAppendix.self, property: "appendix")
}
