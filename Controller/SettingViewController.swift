import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let content = ["selectColor", "darkMode"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        tableView.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "switchCell")
        
        self.title = NSLocalizedString("setting", comment: "");
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 23), NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return self.content.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell;
        cell._label?.textColor = UIColor(named: "custom_text_color");
        cell._label?.text = NSLocalizedString(self.content[indexPath.row], comment: "") ;
        return cell
        default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell;
            cell._label?.textColor = UIColor(named: "custom_text_color");
        cell._label?.text = NSLocalizedString(self.content[indexPath.row], comment: "") ;
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showColorPicker", sender: nil)
        default:
            return;
        }
    }

}
