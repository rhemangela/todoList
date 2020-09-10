//
//  ViewController.swift
//  todoList
//
//  Created by Angela on 26/7/2020.
//  Copyright © 2020 AT Production. All rights reserved.
//

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
    var testing = ["1","2","3","4"];
    var itemArray = [Item_]();
    var listArray = [todoList]();
    var items : Results<Item_>!;
    let realm = try! Realm();
    
    @IBAction func whenEditEnd(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        items = realm.objects(Item_.self);
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask));
        loadCoreData();
        self.tableView.reloadData();
//       if let temp = defaults.array(forKey: "tempArray") as? [arrayItem] {tempArray = temp;}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.row == self.testing.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! AddNewItemTableViewCell;
//            cell._todoLabel?.text = "+ add new items...";
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TodoListTableViewCell;
            cell._todoLabel?.text = self.testing[indexPath.row];
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.testing.count+1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1;
    }
    
    //when tapping cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row]);
//        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone;
//        tableView.deselectRow(at: indexPath, animated: true);
//        tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        if (indexPath.row == self.testing.count){
            let cell = tableView.cellForRow(at: indexPath) as! AddNewItemTableViewCell;
            let newItem = Item_();
            cell.configure(text:"testing", placeholder:"加入新項目...")
            newItem.issue = "hi";
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
    
//    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
//    var inputField = UITextField();
//    let alert = UIAlertController(title: "hello world!", message: "let say something...", preferredStyle: UIAlertController.Style.alert);
//    let action = UIAlertAction(title: "hit", style: UIAlertAction.Style.default) { (UIAlertAction) in
//                let newItem = Item(context: self.context);
//                newItem.issue = inputField.text!;
//                self.tempArray.append(newItem);
//                self.saveData();
//                print(self.tempArray);
        //        self.defaults.set(self.tempArray, forKey: "tempArray");
//        alert.addAction(action);
//        alert.addTextField { (UITextField) in
//                UITextField.placeholder = "eg. angela";
//                inputField = UITextField;
//            }
//        present(alert,animated: true, completion: nil);
//          }
//            };

    
    func loadCoreData(){
//        let request : NSFetchRequest<Item> = Item.fetchRequest();
//        do { tempArray = try context.fetch(request)}
//        catch { print(".....\(error)")}
    }
    
    func saveItem(newItem:Item_){
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

