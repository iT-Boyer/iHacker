//
//  JHUnitOrgBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/1/10.
//

import UIKit

class JHUnitOrgBaseCell: UITableViewCell {

    typealias AddClosure = (JHUnitOrgBaseModel)->()
    var rootView:UIView!
    var name:UILabel!
    var addr:UILabel!
    var creditCode:UILabel!
    var licenceCode:UILabel!
    
    var SelecteAction:AddClosure!
    var block:(()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .init(hexString: "F5F5F5")
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model:JHUnitOrgBaseModel!{
        didSet{
            let nameStr = "企业名称：" + (model.companyName ?? "")
            let addrStr = "地       址：" + (model.address ?? "")
            name.text = nameStr
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let emptylen = addr.font.pointSize * 5
            paragraphStyle.headIndent = emptylen
            var attr:NSAttributedString!
            if #available(iOS 15, *) {
                var attrNew = AttributedString(addrStr)
                attrNew.font = .systemFont(ofSize: 15)
                attrNew.foregroundColor = .init(hexString: "333333")
                attrNew.paragraphStyle = paragraphStyle
                attr = NSAttributedString(attrNew)
            } else {
                // Fallback on earlier versions
                let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 16),
                                                            .foregroundColor: UIColor(hexString: "333333")!,
                                                           .paragraphStyle:paragraphStyle]
                attr = NSAttributedString.init(string: addrStr, attributes: arr)
            }
            addr.attributedText = attr
            //隐藏逻辑
            if let code = model.licenceCode, code.count > 0 {
                let licenceCodeStr = "许可证号："+code
                licenceCode.text = licenceCodeStr
                licenceCode.snp.updateConstraints { make in
                    make.height.equalTo(45)
                }
                licenceCode.isHidden = false
                let line = licenceCode.subviews[0]
                line.isHidden = false
            }else{
                licenceCode.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                licenceCode.isHidden = true
            }
            
            if model.creditCode!.count > 0 {
                let creditCodeStr = "信用代码："+model.creditCode!
                creditCode.text = creditCodeStr
                creditCode.snp.updateConstraints { make in
                    make.height.equalTo(45)
                }
                creditCode.isHidden = false
                let line = creditCode.subviews[0]
                line.isHidden = licenceCode.isHidden ? true : false
            }else{
                creditCode.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                creditCode.isHidden = true
                let line = creditCode.subviews[0]
                line.isHidden = true
            }
            
            if creditCode.isHidden && licenceCode.isHidden {
                let line = addr.subviews[0]
                line.isHidden = true
            }else{
                let line = addr.subviews[0]
                line.isHidden = false
            }
        }
    }
    func createView() {
        rootView = UIView()
        rootView.backgroundColor = .white
        rootView.layer.cornerRadius = 4
        name = createLab()
        name.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showName))
        name.addGestureRecognizer(tap)
        addr = createLab()
        addr.numberOfLines = 0
        creditCode = createLab()
        licenceCode = createLab()
        let line = licenceCode.subviews[0]
        line.isHidden = true
        rootView.addSubview(name)
        rootView.addSubview(addr)
        rootView.addSubview(creditCode)
        rootView.addSubview(licenceCode)
        contentView.addSubview(rootView)
        
        rootView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.centerY.equalToSuperview()
        }
        name.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalToSuperview()
            make.height.equalTo(45)
        }
        addr.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(name.snp.bottom)
            make.height.greaterThanOrEqualTo(45)
        }
        creditCode.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(addr.snp.bottom)
            make.height.equalTo(45)
        }
        licenceCode.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(creditCode.snp.bottom)
            make.height.equalTo(45)
            make.bottom.equalToSuperview()
        }
    }
    
    func createLab() -> UILabel {
        let lab = UILabel()
        lab.textColor = .init(hexString: "333333")
        lab.font = .systemFont(ofSize: 15)
        let line = UIView()
        line.backgroundColor = .init(hexString: "EEEEEE")
        lab.addSubview(line)
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width - 48)
        }
        return lab
    }
    
    @objc
    func showName() {
        // DONE: 浮动提示门店名称
        let alert = JHUnitOrgAlertController()
        alert.showMessage(self.model.companyName ?? "", after: 3, style: .JHAlertControllerStyleToast)
        UIViewController.topMostVC?.present(alert, animated: true, completion: nil)
    }
}
