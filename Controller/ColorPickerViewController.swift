import UIKit
import IGColorPicker

class ColorPickerViewController: UIViewController, ColorPickerViewDelegateFlowLayout,ColorPickerViewDelegate {

    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var selectColorLabel: UILabel!
    
    let RealmManager = DBManager._realm;
    
      override func viewDidLoad() {
        super.viewDidLoad();
        
        colorPickerView.layoutDelegate = self;
        colorPickerView.delegate = self;
        
        // self.view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.25, alpha: 1.0);
        //place to change background color
        selectColorLabel.textColor = UIColor(named: "custom_text_color");
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
        self.RealmManager.defaults.setColor(color: colorPickerView.colors[indexPath.row], forKey: "colorTheme")
    }
}

