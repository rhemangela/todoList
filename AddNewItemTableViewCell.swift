import UIKit

protocol CustomCellDelegate {
    func addNewItem(string:String);
}

class AddNewItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var newItemTickBox: UIImageView!
    var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        newItemTextField.placeholder = NSLocalizedString("addNewItem", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
        newItemTextField.delegate = self as UITextFieldDelegate
    }
    
    public func configure(placeholder: String) {
        newItemTextField.text = "";
        newItemTextField.placeholder = placeholder
        newItemTextField.accessibilityLabel = placeholder
        }
    
    //when tag outside textfield ||  press DONE button
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.configNewItem();
    }
    
    // when press RETURN button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.configNewItem();
        return true
    }
    
    //proccess new item
    func configNewItem(){
        if let newItem = newItemTextField.text {
        if (!newItem.isEmpty){
            delegate?.addNewItem(string: newItem);
            newItemTextField.text = "";
            newItemTextField.placeholder = NSLocalizedString("addNewItem", comment: "")
//            newItemTextField.placeholder = "+ add new item....";
            }
        else {
            newItemTickBox.isHidden = true;
        }}
    }
}
