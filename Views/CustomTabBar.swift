import UIKit

class CustomTabBar: UITabBar {
    
    var themeColor:UIColor = UIColor(red: 0.88, green: 0.47, blue: 0.48, alpha: 1.0);
    
    override var tintColor: UIColor!{
    get { return themeColor}
    set {}
    }
    
    override var selectedImageTintColor: UIColor!{
    get { return themeColor}
    set {}
    }
}
