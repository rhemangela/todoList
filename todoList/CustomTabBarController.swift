import UIKit
import RealmSwift

protocol AddNewListDelegate {
    func addNewList(string:String);
}

class CustomTabBarController: UITabBarController,  UITabBarControllerDelegate  {

    var _delegate: AddNewListDelegate?
    let realm = try! Realm();
    var lists: Results<todoList>!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.delegate = self;
        lists = realm.objects(todoList.self);
        self.setupMiddleButton();
    }
    
        func setupMiddleButton() {

            let image = UIImage(named: "plus") as UIImage?
            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            
            middleBtn.setImage(image, for: .normal)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
            self.tabBar.addSubview(middleBtn)
            self.view.layoutIfNeeded()
        }

        @objc func menuButtonAction(sender: UIButton) {
            print("middle btn");
            //self.selectedIndex = 2
            //to select the middle tab. use "1" if you have only 3 tabs.
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
//                            self.createNewList(name: listName)
                            print("can create");
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

}
