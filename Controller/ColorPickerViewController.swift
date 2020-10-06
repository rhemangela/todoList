import UIKit
import IGColorPicker

class ColorPickerViewController: UIViewController, ColorPickerViewDelegateFlowLayout,ColorPickerViewDelegate {

    var colorPickerView: ColorPickerView!


      override func viewDidLoad() {
        super.viewDidLoad();
        let frameSize = self.view.frame.size;
        colorPickerView = ColorPickerView(frame: CGRect(x: 10, y: 300, width: 350, height: 450));
//        colorPickerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(colorPickerView);
        
        colorPickerView.layoutDelegate = self;
        colorPickerView.delegate = self;
        
        let constraintX = NSLayoutConstraint(item: colorPickerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        let constraintTop = NSLayoutConstraint(item: colorPickerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150);
        NSLayoutConstraint.activate([constraintX, constraintTop]);
        view.layoutIfNeeded();
      }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 60)
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
        print(indexPath.row);
    }
}

