import UIKit

class AddNewItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var newItemTickBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(placeholder: String) {
        newItemTextField.text = "";
        newItemTextField.placeholder = placeholder
        newItemTextField.accessibilityLabel = placeholder
        }
}
