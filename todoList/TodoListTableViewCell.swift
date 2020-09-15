import UIKit

protocol TodoCellDelegate{
    
}

class TodoListTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var _tickBox: UIImageView!
    @IBOutlet weak var _todoLabel: UILabel!
    var delegate: TodoCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
