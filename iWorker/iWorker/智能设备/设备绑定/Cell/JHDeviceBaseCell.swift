//
//  JHDeviceBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
import JHBase
import SnapKit
//支持的三种样式cellid
enum DeviceCellStyle:String {
    case SN = "JHDeviceSNCell"
    case Scence = "JHDeviceSceneCell"
    case Nick = "JHDeviceNickCell"
}

protocol JHViewBindableProtocol {
    associatedtype Model
    func bind(viewModel vm:Model)
}
//Swift的组合运算符&支持将一个类和一个协议结合起来
typealias VBindable<Model> = JHDeviceBaseCell<Model> & JHViewBindableProtocol

/// 实现通用布局
class JHDeviceBaseCell<Model>: UITableViewCell {
    
    var kvoToken: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {}
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = .systemFont(ofSize: 15, weight: .bold)
        titleLab.textColor = .initWithHex("2F3856")
        return titleLab
    }()
    
    func layoutView(first:UILabel, second:UIView, third:UIView? = nil) {
        var arrView = [first,second]
        if let view = third {
            arrView.append(view)
        }
        first.setContentHuggingPriority(.required, for: .horizontal)
        let stack = UIStackView(arrangedSubviews: arrView, axis: .horizontal)
        stack.spacing = 10
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    deinit {
        kvoToken?.invalidate()
    }
}
