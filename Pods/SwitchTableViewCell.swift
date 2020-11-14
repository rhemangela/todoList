import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var _label: UILabel!
    static let identifier = "switchCell";
    static func nib()-> UINib {
        return UINib(nibName: "SwitchTableViewCell", bundle: nil)
    }

    @IBAction func onToggle(_ sender: UISwitch) {

        if sender.isOn == true {    // 判斷使用者選擇是開還是關
            print("on");
              } else {
            print("off");
              }
    }
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clear;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
