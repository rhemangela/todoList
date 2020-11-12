import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var _label: UILabel!
    static let identifier = "switchCell";
    static func nib()-> UINib {
        return UINib(nibName: "SwitchTableViewCell", bundle: nil)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func onToggle(_ sender: Any) {
        print("hello world");
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
