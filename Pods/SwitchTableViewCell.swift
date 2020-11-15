import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var _modeSwitch: UISwitch!
    @IBOutlet weak var _label: UILabel!
    static let identifier = "switchCell";
    static func nib()-> UINib {
        return UINib(nibName: "SwitchTableViewCell", bundle: nil)
    }

    @IBAction func onToggle(_ sender: UISwitch) {
        if sender.isOn == true {
            window?.overrideUserInterfaceStyle = .dark
              } else {
            window?.overrideUserInterfaceStyle = .light
              }
    }
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clear;
        if (UITraitCollection.current.userInterfaceStyle == .dark){
            _modeSwitch.isOn = true
        } else {
            _modeSwitch.isOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
