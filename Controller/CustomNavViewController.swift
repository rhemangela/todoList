import UIKit
import IGColorPicker

class CustomNavViewController: UINavigationController, changeNavBarColorDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let colorPickerView = storyboard.instantiateViewController(withIdentifier: "ColorPickerView") as? ColorPickerViewController
        colorPickerView!.delegate = self;
        present(colorPickerView!, animated: true, completion: nil)
        self.navigationBar.barTintColor = UIColor(red: 0.8, green: 0.61, blue: 0.01, alpha: 1.0);
    }
    
    func changeNavBarColor(color: UIColor) {
        self.navigationBar.barTintColor = color;
        self.navigationBar.setNeedsLayout()
        self.navigationBar.layoutIfNeeded()
        self.navigationBar.setNeedsDisplay()
    }
}
