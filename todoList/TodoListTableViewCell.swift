import UIKit

protocol TodoCellDelegate{
    
}

class TodoListTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var _tickBox: UIImageView!
    @IBOutlet weak var _heart: UIImageView!
    @IBOutlet weak var _todoLabel: UILabel!
    var delegate: TodoCellDelegate?

    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 1.0, green: 0.99, blue: 0.99, alpha: 1.0);
        super.awakeFromNib();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
