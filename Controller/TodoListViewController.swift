import UIKit
import CoreData
import RealmSwift
import IQKeyboardManagerSwift

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    //    let defaults = UserDefaults.standard;
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    let realm = try! Realm();
    var listArray = [todoList]();
    var items : Results<Item_>!;
    var _currentPath :IndexPath = [0,0];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        items = realm.objects(Item_.self);
        loadCoreData();
        self.tableView.reloadData();
        self.tableView.tableFooterView = UIView();
        self._currentPath = [0, self.items.count];
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask));
//       if let temp = defaults.array(forKey: "tempArray") as? [arrayItem] {tempArray = temp;}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.row == self.items.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! AddNewItemTableViewCell;
            cell.newItemTickBox.isHidden = true;
//            cell._todoLabel?.text = "+ add new items...";
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TodoListTableViewCell;
            cell._todoLabel?.text = self.items[indexPath.row].issue;
            cell._tickBox.image = items[indexPath.row].isDone ? UIImage(named: "check-square-gray.png") : UIImage(named: "square-regular.png");
            cell._todoLabel.textColor =  items[indexPath.row].isDone ? UIColor(red: 0.672, green: 0.675, blue: 0.706, alpha: 1.0) : UIColor.black;
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count+1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1;
    }
    
    //when tapping cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select");
        if (indexPath.row != self.items.count){
            let cell = tableView.cellForRow(at: indexPath) as! TodoListTableViewCell;
            do { try realm.write {
                items[indexPath.row].isDone = !items[indexPath.row].isDone;
                }
            }
            catch {print(error)}
            cell._tickBox.image = items[indexPath.row].isDone ? UIImage(named: "check-square-regular.png") : UIImage(named: "square-regular.png");
            self.tableView.reloadData();
        } else if (indexPath.row == self.items.count){
            let cell = self.tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            cell.newItemTickBox.isHidden = false;
            cell.newItemTextField.isEnabled = true;
            cell.newItemTextField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect,\(indexPath.row)");
        
        if (indexPath.row == self.items.count){
            let cell = tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            if !(cell.newItemTextField.text?.isEmpty)!
            {
                self.saveItem(newItemText: cell.newItemTextField.text!);
                cell.newItemTickBox.isHidden = true;
            }
            cell.configure(placeholder:"+ add new item....");
            cell.newItemTextField.isEnabled = false;
    }
    }

    //swipe to delete cell
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            itemArray.remove(at: indexPath.row);
//            tableView.deleteRows(at: [indexPath], with: .none)
//        }
//    }
    
    //todo trailing action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            do { try self.realm.write {
                self.realm.delete(self.items[indexPath.row])
                }}
            catch { print(error)};
            self.tableView.deleteRows(at: [indexPath], with: .none);
            self.tableView.reloadData();
            completion(true)
        }
        delete.backgroundColor =  UIColor(red: 0.991, green: 0.184, blue: 0.462, alpha: 1.0)
     
        let edit = UIContextualAction(style: .normal, title: "Added") { (action, view, completion) in
        let cell = self.tableView.cellForRow(at: indexPath) as! TodoListTableViewCell;
        cell._todoLabel.isEnabled = true;
            self.tableView.isEditing = true;
            completion(false)
        }
        edit.image = UIImage(named: "Small Image")
        edit.backgroundColor =  UIColor(red: 0.2436070212, green: 0.5393256153, blue: 0.1766586084, alpha: 1)
     
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
     
        return config
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textfielddidendediting")
    }
    
    ///handle done button in keyboard
//    @objc func doneButtonClicked(_ sender: Any) {
//        if (self._currentPath.row == self.items.count){
//            let cell = tableView.cellForRow(at: self._currentPath) as! AddNewItemTableViewCell;
//                if !(cell.newItemTextField.text?.isEmpty)!
//                {
//                    self.saveItem(newItemText: cell.newItemTextField.text!);
////                    cell.newItemTickBox.isHidden = true;
//                }
//                cell.configure(placeholder:"+ add new item....");
//                cell.newItemTextField.isEnabled = false;
//            self.tableView.reloadData();
//        }
//    }
    
    @IBAction func addNewFolder(_ sender: UIBarButtonItem) {
    var inputField = UITextField();
    let alert = UIAlertController(title: "新增清單", message: "請輪入名稱...", preferredStyle: UIAlertController.Style.alert);
    let confirmAction = UIAlertAction(title: "確定", style: UIAlertAction.Style.default) { (UIAlertAction) in
        let newList = todoList()
        newList.title = inputField.text!;
        self.listArray.append(newList);
        self.saveList(newList: newList);
    };
    let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(confirmAction);
    alert.addAction(cancelAction);
    alert.addTextField { (UITextField) in
            UITextField.placeholder = "例如： 1/9購物單";
            inputField = UITextField;
        }
    present(alert,animated: true, completion: nil);
      }
    
    func loadCoreData(){
//        let request : NSFetchRequest<Item> = Item.fetchRequest();
//        do { tempArray = try context.fetch(request)}
//        catch { print(".....\(error)")}
    }
    
    func saveItem(newItemText:String){
        let newItem = Item_();
        newItem.issue = newItemText;
        do { try realm.write{
            realm.add(newItem)
            }}
        catch {print(error)};
        self.tableView.reloadData();
    }
    
    func saveList(newList:todoList){
        do { try realm.write{
            realm.add(newList)
            }}
        catch {print(error)};
        self.tableView.reloadData();
    }
    
}

