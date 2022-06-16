//
//  JHswift
//  iWorker
//  Swift —UISwitch/UISegmentedControl的使用
//  https://www.jianshu.com/p/2718904b4250
//  Created by boyer on 2022/5/30.
//

import UIKit
import JHBase

extension UISegmentedControl {
    
    /// 自定义样式
    ///
    /// - Parameters:
    ///   - normalColor: 普通状态下背景色
    ///   - selectedColor: 选中状态下背景色
    ///   - dividerColor: 选项之间的分割线颜色
    func setSegmentStyle(normalColor: UIColor,
                         selectedColor: UIColor,
                         dividerColor: UIColor,
                         normal:[NSAttributedString.Key:Any],
                         selected:[NSAttributedString.Key:Any]) {
        
        let normalColorImage = UIImage(color:normalColor, size: CGSize(width: 1.0, height: 1.0))
        let selectedColorImage = UIImage(color:selectedColor, size: CGSize(width: 1.0, height: 1.0))
        let dividerColorImage = UIImage(color:dividerColor, size: CGSize(width: 1.0, height: 1.0))
        
        setBackgroundImage(normalColorImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedColorImage, for: .selected, barMetrics: .default)
        setDividerImage(dividerColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // 文字在两种状态下的颜色
        setTitleTextAttributes(normal, for: .normal)
        setTitleTextAttributes(selected, for: .selected)
        
        // 边界颜色、圆角
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = dividerColor.cgColor
        self.layer.masksToBounds = true
    }
}

class JHSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(frame: .zero)    // 解决13系统初始化崩溃。
        guard let titles = items as? [String] else {
            return
        }
        segmentTitles = titles
//        super.init(items: items)
        //是否根据segment的内容改变segment的宽度
        apportionsSegmentWidthsByContent = true
        // 选项颜色
        tintColor = .k2F3856
        // 默认选中第一项
        selectedSegmentIndex = 0
        clearStyle()
    }
    
    convenience init(items: [Any]?,
                     normal:[NSAttributedString.Key:Any],
                     selected:[NSAttributedString.Key:Any]) {
        self.init(items: items)
        setTitleTextAttributes(normal, for: .normal)
        setTitleTextAttributes(selected, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func clearStyle() {
        //去除背景色
        let clearimg = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        setBackgroundImage(clearimg, for: .normal, barMetrics: .default)
        setBackgroundImage(clearimg, for: .selected, barMetrics: .default)
        // 去除分割线
        let clear = UIImage(color: .clear, size: CGSize(width: 0, height: 0))
        setDividerImage(clear, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setDividerImage(clear, forLeftSegmentState: .selected, rightSegmentState: .selected, barMetrics: .default)
    }
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .k2CD773
        return line
    }()
}

// 添加下划线和选中动画
extension JHSegmentedControl
{
    //当需要下划线样式时，需要调用该方法
    func addBottomline(){
        addSubview(line)
        //下划线
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    //下划线动画
    func animateLine() {
        let x = Int(bounds.size.width)/numberOfSegments * selectedSegmentIndex + 20
//        let width = widthForSegment(at: selectedSegmentIndex)
        line.snp.updateConstraints { make in
//            make.width.equalTo(width)
            make.left.equalToSuperview().offset(x)
        }
    }
}
