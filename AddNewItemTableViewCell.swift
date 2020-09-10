import UIKit

class AddNewItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var newItemTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(text: String?, placeholder: String) {
        newItemTextField.text = text
        newItemTextField.placeholder = placeholder
        newItemTextField.accessibilityValue = text
        newItemTextField.accessibilityLabel = placeholder
        }
}
