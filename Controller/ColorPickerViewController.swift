import UIKit
import IGColorPicker

class ColorPickerViewController: UIViewController, ColorPickerViewDelegateFlowLayout,ColorPickerViewDelegate {

    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var selectColorLabel: UILabel!
    
      override func viewDidLoad() {
        super.viewDidLoad();
        
        colorPickerView.layoutDelegate = self;
        colorPickerView.delegate = self;
        
        selectColorLabel.text = NSLocalizedString("selectColorMsg", comment: "");
      }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 30, height: 30)
      // WIDTH AND HEIGHT MUST BE EQUALS!
    }

    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      10
    }

    func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      10
    }

    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        
        UINavigationBar.appearance().barTintColor = colorPickerView.colors[indexPath.row];
        UITabBar.appearance().tintColor = colorPickerView.colors[indexPath.row];
        self.navigationController?.navigationBar.barTintColor = colorPickerView.colors[indexPath.row];
    }
}

