import UIKit

class ListPickerView: UIPickerView {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 80
    }

}
