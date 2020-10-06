import UIKit

class SettingTableViewController: UITableViewController {
    
    let content = ["changeThemeColor", "aboutThisApp"];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 23), NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath);
        cell.textLabel?.font = UIFont(name:"System Font Regular", size:23);
        cell.textLabel?.text = self.content[indexPath.row];

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            performSegue(withIdentifier: "showColorPicker", sender: nil)
        }
    }

}
