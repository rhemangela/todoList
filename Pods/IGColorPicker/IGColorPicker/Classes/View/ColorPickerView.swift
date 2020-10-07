//
// Copyright (c) 2017 iGenius Srl
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

public enum ColorPickerViewStyle {
    case square
    case circle
}

public enum ColorPickerViewSelectStyle {
    case check
    case none
}

open class ColorPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Open properties
    
    /// Array of UIColor you want to show in the color picker
    open var colors: [UIColor] = [#colorLiteral(red: 1, green: 0.5411764706, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1),
                                  #colorLiteral(red: 0.5652894378, green: 0.6949481368, blue: 0, alpha: 1), #colorLiteral(red: 0.171055764, green: 0.6274157763, blue: 0.5123413205, alpha: 1), #colorLiteral(red: 0.2419321835, green: 0.4332072735, blue: 0.5136573911, alpha: 1),
                                  #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.4509803922, green: 0.0431372549, blue: 0.1960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.07450980392, blue: 0.2156862745, alpha: 1),
                                  #colorLiteral(red: 1, green: 1, blue: 0.5529411765, alpha: 1), #colorLiteral(red: 0.9925034642, green: 0.8121734858, blue: 0, alpha: 1), #colorLiteral(red: 0.8, green: 0.6117647059, blue: 0.007843137255, alpha: 1),
                                  #colorLiteral(red: 0.7019607843, green: 0.5333333333, blue: 1, alpha: 1), #colorLiteral(red: 0.4495905638, green: 0.3577245474, blue: 0.8001251817, alpha: 1), #colorLiteral(red: 0.3522524834, green: 0.2723381221, blue: 0.6589055657, alpha: 1),
                                  #colorLiteral(red: 1, green: 0.8196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 0.8879843354, green: 0.5014117956, blue: 0, alpha: 1), #colorLiteral(red: 0.8121558428, green: 0.338460505, blue: 0, alpha: 1),
                                  #colorLiteral(red: 0.6029270887, green: 0.6671635509, blue: 0.8504692912, alpha: 1), #colorLiteral(red: 0.2389388382, green: 0.5892125368, blue: 0.8818323016, alpha: 1), #colorLiteral(red: 0.1919409633, green: 0.4961107969, blue: 0.745100379, alpha: 1),
                                  #colorLiteral(red: 0.920953393, green: 0.447560966, blue: 0.4741248488, alpha: 1), #colorLiteral(red: 0.8349413276, green: 0.3352985978, blue: 0.3409483433, alpha: 1), #colorLiteral(red: 0.7378575206, green: 0.2320150733, blue: 0.1414205134, alpha: 1),
                                  #colorLiteral(red: 0.5019607843, green: 0.8470588235, blue: 1, alpha: 1), #colorLiteral(red: 0.3169852495, green: 0.3903964162, blue: 0.6502153277, alpha: 1), #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1),
                                  #colorLiteral(red: 0.6344745755, green: 0.5274511576, blue: 0.4317585826, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.3333333333, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.3104358912, green: 0.2327643633, blue: 0.163685441, alpha: 1),
                                  #colorLiteral(red: 0.5176470588, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.8980392157, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.7215686275, blue: 0.831372549, alpha: 1),
                                  #colorLiteral(red: 0.2082854211, green: 0.2843391895, blue: 0.3764083385, alpha: 1), #colorLiteral(red: 0.1762744784, green: 0.2414814532, blue: 0.3204131126, alpha: 1), #colorLiteral(red: 0.1490027606, green: 0.1490303874, blue: 0.1489966214, alpha: 1)] {
        didSet {
            if colors.isEmpty {
                fatalError("ERROR ColorPickerView - You must set at least 1 color!")
            }
        }
    }
    /// The object that acts as the layout delegate for the color picker
    open weak var layoutDelegate: ColorPickerViewDelegateFlowLayout?
    /// The object that acts as the delegate for the color picker
    open weak var delegate: ColorPickerViewDelegate?
    /// The index of the selected color in the color picker 
    open var indexOfSelectedColor: Int? {
        return _indexOfSelectedColor
    }
    /// The index of the preselected color in the color picker
    open var preselectedIndex: Int? {
        didSet {
            if let index = preselectedIndex {
                
                guard index >= 0, colors.indices.contains(index) else {
                    print("ERROR ColorPickerView - preselectedItem out of colors range")
                    return
                }
                
                _indexOfSelectedColor = index
                
                collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    /// If true, the selected color can be deselected by a tap
    open var isSelectedColorTappable: Bool = true
    /// If true, the preselectedIndex is showed in the center of the color picker
    open var scrollToPreselectedIndex: Bool = false
    /// Style of the color picker cells
    open var style: ColorPickerViewStyle = .circle
    /// Style applied when a color is selected
    open var selectionStyle: ColorPickerViewSelectStyle = .check
    
    // MARK: - Private properties
    
    fileprivate var _indexOfSelectedColor: Int?
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorPickerCell.self, forCellWithReuseIdentifier: ColorPickerCell.cellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - View management
    
    open override func layoutSubviews() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        // Check on scrollToPreselectedIndex
        if preselectedIndex != nil, !scrollToPreselectedIndex {
            // Scroll to the first color
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    // MARK: - Private Methods
    
    private func _selectColor(at indexPath: IndexPath, animated: Bool) {
        
        guard let colorPickerCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else { return }
        
        if indexPath.item == _indexOfSelectedColor, !isSelectedColorTappable {
            return
        }
        
        if selectionStyle == .check {
            
            if indexPath.item == _indexOfSelectedColor {
                if isSelectedColorTappable {
                    _indexOfSelectedColor = nil
                    colorPickerCell.checkbox.setCheckState(.unchecked, animated: animated)
                }
                return
            }
            
            _indexOfSelectedColor = indexPath.item
            
            colorPickerCell.checkbox.tintColor = colors[indexPath.item].isWhiteText ? .white : .black
            colorPickerCell.checkbox.setCheckState((colorPickerCell.checkbox.checkState == .checked) ? .unchecked : .checked, animated: animated)
            
        }
        
        delegate?.colorPickerView(self, didSelectItemAt: indexPath)
    
    }
    
    // MARK: - Public Methods
    
    public func selectColor(at index: Int, animated: Bool) {
        self._selectColor(at: IndexPath(row: index, section: 0),
                          animated: animated)
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPickerCell.cellIdentifier, for: indexPath) as! ColorPickerCell
        
        cell.backgroundColor = colors[indexPath.item]
        
        if style == .circle {
            cell.layer.cornerRadius = cell.bounds.width / 2
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let colorPickerCell = cell as! ColorPickerCell
        
        guard selectionStyle == .check else { return }
        
        guard indexPath.item == _indexOfSelectedColor else {
            colorPickerCell.checkbox.setCheckState(.unchecked, animated: false)
            return
        }
        
        colorPickerCell.checkbox.tintColor = colors[indexPath.item].isWhiteText ? .white : .black
        colorPickerCell.checkbox.setCheckState(.checked, animated: false)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self._selectColor(at: indexPath, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // Check if the old color cell is showed. If true, it deselects it
        guard let oldColorCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else {
            return
        }
        
        if selectionStyle == .check {
            oldColorCell.checkbox.setCheckState(.unchecked, animated: true)
        }
        
        delegate?.colorPickerView?(self, didDeselectItemAt: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layoutDelegate = layoutDelegate,
            let sizeForItemAt = layoutDelegate.colorPickerView?(self, sizeForItemAt: indexPath) {
            return sizeForItemAt
        }
        return DefaultValues.cellSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumLineSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumLineSpacingForSectionAt: section) {
            return minimumLineSpacingForSectionAt
        }
        return DefaultValues.minimumLineSpacingForSectionAt
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumInteritemSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumInteritemSpacingForSectionAt: section) {
            return minimumInteritemSpacingForSectionAt
        }
        return DefaultValues.minimumInteritemSpacingForSectionAt
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layoutDelegate = layoutDelegate, let insetForSectionAt = layoutDelegate.colorPickerView?(self, insetForSectionAt: section) {
            return insetForSectionAt
        }
        return DefaultValues.insets
    }
    
}
