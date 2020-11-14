import UIKit
import CoreData
import RealmSwift
import IQKeyboardManagerSwift

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,  CustomCellDelegate, TodoCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fullScreenSize = UIScreen.main.bounds.size;
    let listPicker: UIPickerView = UIPickerView();
    let navBarBtn =  UIButton(type: .custom);

    let defaults = UserDefaults.standard;
    let realm = try! Realm();
    var all_items: Results<Item_>!;
    var selected_items : Results<Item_>!;
    var lists: Results<todoList>!;
    var currentListName = "";
    var selectedListIndex = 0;
    var darkMode = false;

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        tableView.tableFooterView = UIView();
        
        lists = realm.objects(todoList.self); //all todoList instances in Realm
        all_items = realm.objects(Item_.self);// all item instances in Realm

        currentListName = defaults.string(forKey: "lastOpenList") ?? "New List";
        
        if (lists.isEmpty){
            createNewList(name: currentListName)
        } else {
//            currentListName = lists[lists.count-1].title;
            self.loadListItems();
        }
        
        initNavBar(); // make navBar title clickable to choose list
        self.title = NSLocalizedString("list", comment: "");
        //tabbar item name
        self.tableView.reloadData();
        print("folder of Realm,\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))");
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.row == self.selected_items.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! AddNewItemTableViewCell;
            cell.delegate = self;
            cell.newItemTickBox.isHidden = true;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TodoListTableViewCell;
            cell.delegate = self;
            cell._todoLabel?.text = self.selected_items[indexPath.row].issue;
            cell._tickBox.image = selected_items[indexPath.row].isDone ? UIImage(named: "select_on.png") : UIImage(named: "select_off.png");
            cell._heart.image = selected_items[indexPath.row].isImportant ? UIImage(named: "heart-solid.png") : .none;
            cell._todoLabel.textColor =  selected_items[indexPath.row].isDone ? UIColor(named: "custom_text_gray_color") : UIColor(named: "custom_text_color");
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.items.count+1;
    
        if let listItems = selected_items {
            return listItems.count+1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //when tapping cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != self.selected_items.count){
            let cell = tableView.cellForRow(at: indexPath) as! TodoListTableViewCell;
            do { try realm.write {
                selected_items[indexPath.row].isDone = !selected_items[indexPath.row].isDone;
                }
            }
            catch {print("did select row errer,\(error)")}
            cell._tickBox.image = selected_items[indexPath.row].isDone ? UIImage(named: "select_on.png") : UIImage(named: "select_off.png");
            self.tableView.reloadData();
        } else if (indexPath.row == self.selected_items.count){
            let cell = self.tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            cell.newItemTickBox.isHidden = false;
            cell.newItemTextField.isEnabled = true;
            cell.newItemTextField.becomeFirstResponder()
        }
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if (indexPath.row == self.selected_items.count) {
            return false
            } else {
                return true
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
           let delete = UIContextualAction(style: .normal, title: NSLocalizedString("delete", comment: "")) { (action, view, completion) in
            do { try self.realm.write {
                self.realm.delete(self.selected_items[indexPath.row])
                }}
                catch { print("delete row error,\(error)")};
                self.tableView.deleteRows(at: [indexPath], with: .none);
                self.tableView.reloadData();
                   
               completion(true)
           }
        delete.backgroundColor =  UIColor(named: "delete_color");
        
        let important = UIContextualAction(style: .normal, title: self.selected_items[indexPath.row].isImportant ? NSLocalizedString("cancelMarker", comment: "") : NSLocalizedString("markAsImportant", comment: "")) { (action, view, completion) in
            
            do { try self.realm.write {
                self.selected_items[indexPath.row].isImportant = !self.selected_items[indexPath.row].isImportant;
                }
            }
            catch {print("did select row errer,\(error)")};
            print(self.selected_items[indexPath.row].isImportant);
            self.tableView.reloadData();
            
            completion(true)
        }
        important.backgroundColor =  UIColor(named: "remark_color")
        
        
        let config = UISwipeActionsConfiguration(actions: [delete, important]);
        config.performsFirstActionWithFullSwipe = false;
        
           return config
       }
    
    func initNavBar(){
        navBarBtn.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        navBarBtn.setTitle(self.currentListName, for: .normal);
        navBarBtn.titleLabel?.font =  UIFont(name: "System Font Regular", size: 23);
        navBarBtn.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = navBarBtn
    }
    
    func popupListPicker(){
        listPicker.delegate = self;
        listPicker.dataSource = self;
        listPicker.translatesAutoresizingMaskIntoConstraints = false;
        
        let alert = UIAlertController(title: NSLocalizedString("switchFolder", comment: ""), message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet);
        
        alert.view.addSubview(listPicker);
        
        let constraintX = NSLayoutConstraint(item: listPicker, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0);
        let constraintTop = NSLayoutConstraint(item: listPicker, attribute: .top, relatedBy: .equal, toItem: alert.view, attribute: .top, multiplier: 1, constant: 0);
        NSLayoutConstraint.activate([constraintX, constraintTop]);
        alert.view.layoutIfNeeded();
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .default, handler: { (UIAlertAction) in
                self.currentListName = self.lists[self.selectedListIndex].title;
                self.loadListItems();
                self.tableView.reloadData();
                self.navBarBtn.setTitle(self.currentListName, for: .normal);
                }))
                self.present(alert,animated: true, completion: nil )
    }
    
    //choose list
    @objc func clickOnButton() {
        self.popupListPicker();
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lists.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.lists[row].title;
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.lists[row].title);
        selectedListIndex = row;
    }
    
    // add new folder
    @IBAction func addNewFolder(_ sender: UIBarButtonItem) {
    var inputField = UITextField();
    let alert = UIAlertController(title: NSLocalizedString("addNewFolder", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert);
    let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: UIAlertAction.Style.default) { (UIAlertAction) in
        if let listName = inputField.text {
            var isDuplicateName = false;
            if (!listName.trimmingCharacters(in: .whitespaces).isEmpty){
                for item in self.lists {
                    if (item.title == listName){
                        isDuplicateName = true;
                    }
                }
                if (!isDuplicateName) {
                    self.createNewList(name: listName)
                }
            }
        }
    };
    let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(confirmAction);
    alert.addAction(cancelAction);
    alert.addTextField { (UITextField) in
            UITextField.placeholder = NSLocalizedString("enterNewListName", comment: "");
            inputField = UITextField;
        }
    present(alert,animated: true, completion: nil);
      }

    
    @IBAction func deleteFolder(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("deleteListMsg", comment: ""), message: NSLocalizedString("deleteListMsgDetail", comment: ""), preferredStyle: UIAlertController.Style.alert);
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: UIAlertAction.Style.default) { (UIAlertAction) in
            if (self.lists.count > 1) {
                //delete all items in list
                let item = self.realm.objects(Item_.self).filter("ownerList ==  '\(self.currentListName)'");
                try! self.realm.write {
                    self.realm.delete(item)
                }
                //delete current list
                let list = self.realm.objects(todoList.self).filter("title ==  '\(self.currentListName)'");
                try! self.realm.write {
                    self.realm.delete(list)
                }
                self.currentListName = self.lists.last?.title ?? self.currentListName;
            } else { // if there is only one list
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                self.currentListName = "New List";
                self.createNewList(name: "New List")
            }
            self.loadListItems();
            self.tableView.reloadData();
            self.listPicker.reloadAllComponents();
            self.navBarBtn.setTitle(self.currentListName, for: .normal);
        };
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(confirmAction);
        alert.addAction(cancelAction);
        present(alert,animated: true, completion: nil);
    }
    
    func addNewItem(string: String) {
        self.saveItem(newItemText: string);
    }
    
    func loadListItems(){
        self.selected_items = self.all_items.filter("ownerList = '\(currentListName)'");
        defaults.set(currentListName, forKey: "lastOpenList");
    }
    
    func saveItem(newItemText:String){
        let newItem = Item_();
        newItem.issue = newItemText;
        newItem.ownerList = self.currentListName;
        do { try realm.write{
            realm.add(newItem)
            }}
        catch {print("save item error,\(error)")};
        self.tableView.reloadData();
    }
    
    func createNewList(name: String){
        let newList = todoList();
        newList.title = name;
        do { try realm.write{
            realm.add(newList)
            }}
        catch {print("save list error,\(error)")};
        currentListName = name;
        self.loadListItems();
        navBarBtn.setTitle(self.currentListName, for: .normal);
        self.tableView.reloadData();
        self.listPicker.reloadAllComponents();
    }
}
