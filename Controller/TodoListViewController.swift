import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBAction func onEditEnd(_ sender: UITextField) {
        ////////
    }
    @IBOutlet weak var tableView: UITableView!
//    let defaults = UserDefaults.standard;
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
//    var testing = ["1","2","3","4"];
    let realm = try! Realm();
    var itemArray = [Item_]();
    var listArray = [todoList]();
    var items : Results<Item_>!;

    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        items = realm.objects(Item_.self);
        loadCoreData();
        self.tableView.reloadData();
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped));
        self.tableView.addGestureRecognizer(tapGesture);
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask));
//       if let temp = defaults.array(forKey: "tempArray") as? [arrayItem] {tempArray = temp;}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.row == self.items.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! AddNewItemTableViewCell;
//            cell._todoLabel?.text = "+ add new items...";
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TodoListTableViewCell;
            cell._todoLabel?.text = self.items[indexPath.row].issue;
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
        if (indexPath.row != self.items.count){
            let cell = tableView.cellForRow(at: indexPath) as! TodoListTableViewCell;
            cell._tickBox.image = UIImage(named: "check-square-regular.png");
            self.tableView.reloadData();
        }
//        print(itemArray[indexPath.row]);
//        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone;
//        tableView.deselectRow(at: indexPath, animated: true);
//        tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        
        if (indexPath.row == self.items.count){
            let cell = tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            if !(cell.newItemTextField.text?.isEmpty)!
            {
                self.saveItem(newItemText: cell.newItemTextField.text!);
            }
            cell.configure(placeholder:"+ add new item....");
            cell.newItemTextField.isEnabled = false;
    }
    }

    //swipe to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemArray.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .none)
        } else if editingStyle == .insert {

        }
    }
    
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
    
    @objc func tableViewTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.tableView)
        let path = self.tableView.indexPathForRow(at: location);// if empty cell, path = nil
        
        if let indexPathForRow = path {// clicking valid cells
            switch indexPathForRow.row {
                case items.count: // clicking text field
                    let cell = self.tableView.cellForRow(at: indexPathForRow) as! AddNewItemTableViewCell;
                    cell.newItemTextField.isEnabled = true;
                default: //other valid cells
                    let indexPath = IndexPath(row: items.count, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
                    if !(cell.newItemTextField.text?.isEmpty)!
                    {
                        self.saveItem(newItemText: cell.newItemTextField.text!);
                    }
                    cell.configure(placeholder:"+ add new item....");
                    cell.newItemTextField.isEnabled = false;
                    cell.newItemTextField.endEditing(true);
                }
                }
        else{
            let indexPath = IndexPath(row: items.count, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            if !(cell.newItemTextField.text?.isEmpty)!
            {
                self.saveItem(newItemText: cell.newItemTextField.text!);
            }
            cell.configure(placeholder:"+ add new item....");
            cell.newItemTextField.isEnabled = false;
            cell.newItemTextField.endEditing(true);
        }
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

