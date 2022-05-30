//
//  JHswift
//  iWorker
//  Swift —UISwitch/UISegmentedControl的使用
//  https://www.jianshu.com/p/2718904b4250
//  Created by boyer on 2022/5/30.
//

import UIKit
import JHBase

class JHSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        //是否根据segment的内容改变segment的宽度
//        apportionsSegmentWidthsByContent = true
        // 选项颜色
        tintColor = .k2F3856
        // 默认选中第二项
        selectedSegmentIndex = 0
        
        customStyle()
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func customStyle() {
        //去除背景色
        let clearimg = UIImage(color: .white, size: CGSize.init(width: 1, height: 1))
        setBackgroundImage(clearimg, for: .normal, barMetrics: .default)
        // 去除分割线
        let clear = UIImage(color: .clear, size: CGSize.init(width: 0, height: 0))
        setDividerImage(clear, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        selectedSegmentTintColor = .red
        let textattr:[NSAttributedString.Key:Any] = [
            .foregroundColor:UIColor.k2F3856,
            .font:UIFont.systemFont(ofSize: 13)
        ]
        let textattr2:[NSAttributedString.Key:Any] = [
            .foregroundColor:UIColor.k2CD773,
            .font:UIFont.systemFont(ofSize: 16)
        ]
        setTitleTextAttributes(textattr, for: .normal)
        setTitleTextAttributes(textattr2, for: .selected)
    }
    
    func createView(){
        addSubview(line)
        //下划线
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.snp.bottom)
        }
        
    }
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .k2CD773
        return line
    }()
    
    //下划线动画
    func animateLine() {
        let x = Int(bounds.size.width)/3 * selectedSegmentIndex + 20
//        let width = widthForSegment(at: selectedSegmentIndex)
        line.snp.updateConstraints { make in
//            make.width.equalTo(width)
            make.left.equalToSuperview().offset(x)
        }
    }
}
