import UIKit

protocol TodoCellDelegate{
    
}

class TodoListTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var _tickBox: UIImageView!
    @IBOutlet weak var _heart: UIImageView!
    @IBOutlet weak var _todoLabel: UILabel!
    var delegate: TodoCellDelegate?

    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear;
        super.awakeFromNib();
        _todoLabel.textColor = UIColor(named: "custom_text_color");
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
