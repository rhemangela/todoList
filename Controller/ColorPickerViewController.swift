import UIKit
import IGColorPicker

protocol changeNavBarColorDelegate {
    func changeNavBarColor(color:UIColor);
}

class ColorPickerViewController: UIViewController, ColorPickerViewDelegateFlowLayout,ColorPickerViewDelegate {

    @IBOutlet weak var selectColorLabel: UILabel!
    var colorPickerView: ColorPickerView!
    var delegate: changeNavBarColorDelegate?
    
      override func viewDidLoad() {
        super.viewDidLoad();
        
        selectColorLabel.text = NSLocalizedString("selectColorMsg", comment: "");
        colorPickerView = ColorPickerView(frame: CGRect(x: 30, y: 300, width: 300, height: 250));
        let separatorView = UIView.init(frame: CGRect(x: 30, y: 280, width: 300, height: 1))
        separatorView.backgroundColor = .lightGray;
        
//        colorPickerView.translatesAutoresizingMaskIntoConstraints = false;
//        separatorView.translatesAutoresizingMaskIntoConstraints = false;

        
        view.addSubview(colorPickerView);
        view.addSubview(separatorView);
        
        colorPickerView.layoutDelegate = self;
        colorPickerView.delegate = self;
        
        let constraintX_separator = NSLayoutConstraint(item: separatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        let constraintTop_separator = NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150);
        let constraintX = NSLayoutConstraint(item: colorPickerView as Any, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        let constraintTop = NSLayoutConstraint(item: colorPickerView as Any, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150);
        
        NSLayoutConstraint.activate([constraintX_separator, constraintTop_separator, constraintX, constraintTop]);
        view.layoutIfNeeded();
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
        self.delegate?.changeNavBarColor(color: colorPickerView.colors[indexPath.row]);
        self.navigationController?.navigationBar.barTintColor = colorPickerView.colors[indexPath.row]
    }
}

