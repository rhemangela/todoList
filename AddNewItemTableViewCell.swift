import UIKit

protocol CustomCellDelegate {
    func addNewItem(string:String);
}

class AddNewItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var newItemTickBox: UIImageView!
    var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        print("custom cell DidEndEditing");
        self.configNewItem();
    }
    
    // when press RETURN button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("custom cell textFieldShouldReturn");
        textField.resignFirstResponder();
        self.configNewItem();
        return true
    }
    
    //proccess new item
    func configNewItem(){
        if let newItem = newItemTextField.text {
        if (!newItem.isEmpty){
            print("ready to delegate...")
            delegate?.addNewItem(string: newItem);
            newItemTextField.text = "";
            newItemTextField.placeholder = "+ add new item....";
            }
        else {
            newItemTickBox.isHidden = true;
        }}
    }
}
