import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var _label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clear;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
