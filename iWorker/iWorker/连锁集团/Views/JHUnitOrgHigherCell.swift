//
//  JHUnitOrgHigherCell.swift
//  iWorker
//
//  Created by boyer on 2022/2/7.
//

import UIKit

class JHUnitOrgHigherCell: JHUnitOrgBaseCell {
    var ChangeAction:()->() = {}
    override func createView() {
        super.createView()
        let titleView = createTitleView()
        rootView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        self.name.snp.updateConstraints { make in
            make.top.equalTo(15+15+14)
        }
    }
    
    func createTitleView()->UIView {
        let view = UIView()
        let title = UILabel()
        title.text = "我的上级"
        title.textColor = .initWithHex("333333")
        title.font = .systemFont(ofSize: 16, weight: .medium)
        let changeBtn = UIButton()
        changeBtn.titleLabel?.font = .systemFont(ofSize: 12)
        changeBtn.setTitle("更换企业", for: .normal)
        changeBtn.setTitleColor(.initWithHex("04A174"), for: .normal)
        changeBtn.setImage(.init(named: "unitorgchangestore"), for: .normal)
        changeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 12)
        changeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -50)
        changeBtn.addTarget(self, action: #selector(changeBtnAction(btn:)), for: .touchDown)
        view.addSubview(title)
        view.addSubview(changeBtn)
        title.snp.makeConstraints { make in
            make.left.bottom.top.equalTo(0)
        }
        changeBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(0)
        }
        return view
    }
    @objc
    func changeBtnAction(btn:UIButton) {
        self.ChangeAction()
    }
}
