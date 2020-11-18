import UIKit
import CoreData
import RealmSwift
import IQKeyboardManagerSwift

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,  CustomCellDelegate, TodoCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let fullScreenSize = UIScreen.main.bounds.size;
    let listPicker: UIPickerView = UIPickerView();
    let navBarBtn =  UIButton(type: .custom);

    let RealmManager = DBManager._realm;
    var selectedListIndex = 0;
    var darkMode = false;

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        tableView.tableFooterView = UIView();
        
        if (RealmManager.lists.isEmpty){
            createNewList(name: RealmManager.currentListName)
        } else {
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
        if (indexPath.row == RealmManager.selected_items.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! AddNewItemTableViewCell;
            cell.delegate = self;
            cell.newItemTickBox.isHidden = true;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TodoListTableViewCell;
            cell.delegate = self;
            cell._todoLabel?.text = RealmManager.selected_items[indexPath.row].issue;
            cell._tickBox.image = RealmManager.selected_items[indexPath.row].isDone ? UIImage(named: "select_on.png") : UIImage(named: "select_off.png");
            cell._heart.image = RealmManager.selected_items[indexPath.row].isImportant ? UIImage(named: "heart-solid.png") : .none;
            cell._todoLabel.textColor =  RealmManager.selected_items[indexPath.row].isDone ? UIColor(named: "custom_text_gray_color") : UIColor(named: "custom_text_color");
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.items.count+1;
    
        if let listItems = RealmManager.selected_items {
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
        if (indexPath.row != RealmManager.selected_items.count){
            let cell = tableView.cellForRow(at: indexPath) as! TodoListTableViewCell;
            do { try RealmManager.realm.write {
                RealmManager.selected_items[indexPath.row].isDone = !RealmManager.selected_items[indexPath.row].isDone;
                }
            }
            catch {print("did select row errer,\(error)")}
            cell._tickBox.image = RealmManager.selected_items[indexPath.row].isDone ? UIImage(named: "select_on.png") : UIImage(named: "select_off.png");
            self.tableView.reloadData();
        } else if (indexPath.row == RealmManager.selected_items.count){
            let cell = self.tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            cell.newItemTickBox.isHidden = false;
            cell.newItemTextField.isEnabled = true;
            cell.newItemTextField.becomeFirstResponder()
        }
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if (indexPath.row == RealmManager.selected_items.count) {
            return false
            } else {
                return true
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
           let delete = UIContextualAction(style: .normal, title: NSLocalizedString("delete", comment: "")) { (action, view, completion) in
            do { try self.RealmManager.realm.write {
                self.RealmManager.realm.delete(self.RealmManager.selected_items[indexPath.row])
                }}
                catch { print("delete row error,\(error)")};
                self.tableView.deleteRows(at: [indexPath], with: .none);
                self.tableView.reloadData();
                   
               completion(true)
           }
        delete.backgroundColor =  UIColor(named: "delete_color");
        
        let important = UIContextualAction(style: .normal, title: RealmManager.selected_items[indexPath.row].isImportant ? NSLocalizedString("cancelMarker", comment: "") : NSLocalizedString("markAsImportant", comment: "")) { (action, view, completion) in
            
            do { try self.RealmManager.realm.write {
                self.RealmManager.selected_items[indexPath.row].isImportant = !self.RealmManager.selected_items[indexPath.row].isImportant;
                }
            }
            catch {print("did select row errer,\(error)")};
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
        navBarBtn.setTitle(self.RealmManager.currentListName, for: .normal);
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
                    self.RealmManager.currentListName = self.RealmManager.lists[self.selectedListIndex].title;
                self.loadListItems();
                self.tableView.reloadData();
                    self.navBarBtn.setTitle(self.RealmManager.currentListName, for: .normal);
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
        return RealmManager.lists.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        RealmManager.lists[row].title;
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
                for item in self.RealmManager.lists {
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
            if (self.RealmManager.lists.count > 1) {
                //delete all items in list
                let item = self.RealmManager.realm.objects(Item_.self).filter("ownerList ==  '\(self.RealmManager.currentListName)'");
                try! self.RealmManager.realm.write {
                    self.RealmManager.realm.delete(item)
                }
                //delete current list
                let list = self.RealmManager.realm.objects(todoList.self).filter("title ==  '\(self.RealmManager.currentListName)'");
                try! self.RealmManager.realm.write {
                    self.RealmManager.realm.delete(list)
                }
                self.RealmManager.currentListName = self.RealmManager.lists.last?.title ?? self.RealmManager.currentListName;
            } else { // if there is only one list
                try! self.RealmManager.realm.write {
                    self.RealmManager.realm.deleteAll()
                }
                self.RealmManager.currentListName = "New List";
                self.createNewList(name: "New List")
            }
            self.loadListItems();
            self.tableView.reloadData();
            self.listPicker.reloadAllComponents();
            self.navBarBtn.setTitle(self.RealmManager.currentListName, for: .normal);
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
        self.RealmManager.selected_items = self.RealmManager.all_items.filter("ownerList = '\(RealmManager.currentListName)'");
        RealmManager.defaults.set(RealmManager.currentListName, forKey: "lastOpenList");
    }
    
    func saveItem(newItemText:String){
        let newItem = Item_();
        newItem.issue = newItemText;
        newItem.ownerList = self.RealmManager.currentListName;
        do { try RealmManager.realm.write{
            RealmManager.realm.add(newItem)
            }}
        catch {print("save item error,\(error)")};
        self.tableView.reloadData();
    }
    
    func createNewList(name: String){
        let newList = todoList();
        newList.title = name;
        do { try RealmManager.realm.write{
            RealmManager.realm.add(newList)
            }}
        catch {print("save list error,\(error)")};
        RealmManager.currentListName = name;
        self.loadListItems();
        navBarBtn.setTitle(self.RealmManager.currentListName, for: .normal);
        self.tableView.reloadData();
        self.listPicker.reloadAllComponents();
    }
}
