import Foundation
import CoreData
import RealmSwift

class DBManager {
    
    let defaults = UserDefaults.standard;
    let realm = try! Realm();
    var all_items: Results<Item_>!;
    var selected_items : Results<Item_>!;
    var lists: Results<todoList>!;
    var currentListName = "";
    
    static let _realm = DBManager();
    
    init() {
        lists = realm.objects(todoList.self); //all todoList instances in Realm
        all_items = realm.objects(Item_.self);// all item instances in Realm

        currentListName = defaults.string(forKey: "lastOpenList") ?? "New List";
        
    }

}
