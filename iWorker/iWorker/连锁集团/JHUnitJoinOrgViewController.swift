//
//  JHUnitJoinOrgViewController.swift
//  iWorker
//
//  Created by boyer on 2022/1/7.
//

import JHBase
import UIKit

class JHUnitJoinOrgViewController: JHBaseNavVC {

    override func viewDidLoad() {
        createView()
    }
    @objc
    func backAction() {
        self.navigationController?.popViewController()
    }
    
    func createView(){
        self.view.backgroundColor = .white
        //创建/加入组织
        let title = UILabel(text: "创建/加入组织")
        title.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        title.textColor = UIColor(hexString: "333333")
        let subTitle = UILabel(text: "立即体验组织管理模式")
        subTitle.font = UIFont.systemFont(ofSize: 14)
        subTitle.textColor = UIColor(hexString: "BBBBBB")
        let firstpreview = UIImageView(image: .init(named: "firstpreview"))
        let joinOrgView = createCellView(title: "我要加入总公司", content: "选择我的总公司，并加入公司组织下", action: #selector(joinOrgAction(_:)))
        let addChildView = createCellView(title: "我要管理子公司", content: "选择我的子公司，统一建立集团组织并管理", action: #selector(addChildAction(_:)))
        
        let backBtn = UIButton()
        backBtn.setImage(.init(named: "JHUniversalResource.bundle/arrow_left_dark"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchDown)
        self.view.addSubview(title)
        self.view.addSubview(subTitle)
        self.view.addSubview(firstpreview)
        self.view.addSubview(joinOrgView)
        self.view.addSubview(addChildView)
        self.view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(kStatusBarHeight)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        
        //layout
        title.snp.makeConstraints { make in
            make.left.equalTo(34)
            make.centerY.equalToSuperview().offset(-258)
        }
        subTitle.snp.makeConstraints { make in
            make.left.equalTo(34)
            make.top.equalTo(title.snp.bottom).offset(6)
        }
        firstpreview.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300, height: 222))
        }
        joinOrgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(24)
            make.top.equalTo(firstpreview.snp.bottom).offset(4)
        }
        addChildView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(24)
            make.top.equalTo(joinOrgView.snp.bottom)
        }
    }
    
    //
    func createCellView(title:String,content:String,action:Selector) -> UIView {
        let rootView = UIView()
        let backimg = UIImageView(image: .init(named: "unitjoinselect"))
        let titleLab = UILabel()
        titleLab.attributedText = attrFontFor(text: title)
        let lab = UILabel()
        lab.text = content
        lab.textColor = UIColor(hexString: "AEAEAE")
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.numberOfLines = 0
        let arrow = UIImageView(image: .init(named: "unittarrow"))
        
        let tap = UITapGestureRecognizer.init(target: self, action: action)
        rootView.isUserInteractionEnabled = true
        rootView.addGestureRecognizer(tap)
        
        rootView.addSubview(backimg)
        rootView.addSubview(titleLab)
        rootView.addSubview(lab)
        rootView.addSubview(arrow)
        
        rootView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        backimg.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.top.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(35)
        }
        lab.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(titleLab.snp.bottom).offset(10)
        }
        
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 22, height: 22))
        }

        return rootView
    }
    
    func attrFontFor(text:String) -> NSAttributedString {
        
        var attr = AttributedString(text)
        attr.font = .systemFont(ofSize: 16)
        attr.foregroundColor = .init(hexString: "04A174")
        
        let range = attr.range(of: "我要")!
        attr[range].foregroundColor = .init(hexString: "333333")
        
        return NSAttributedString(attr)
        
        let arr = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                   NSAttributedString.Key.foregroundColor:UIColor(hexString: "04A174")
                  ]
        let string = AttributedString(text, attributes: AttributeContainer(arr as [NSAttributedString.Key : Any]))
        return NSAttributedString.init(string)
    }
    
    @objc
    func joinOrgAction(_:UIButton) {
        print("joinOrgAction------")
    }
    
    @objc
    func addChildAction(_:UIButton) {
        print("addChildAction------")
        
    }
}
