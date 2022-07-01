//
//  CheckSignCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import UIKit
import JHBase

class CheckSignCell: CheckEditBaseCell {

    override func updateUI() {
        iconView.image = .init(named: "Inspect签字")
        actionView.addSubview(signView)
        signView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    lazy var signView: UIButton = {
        let sign = UIButton()
        sign.setImage(.init(named: ""), for: .normal)
        sign.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 签名跳转
            let signvc = InsSignViewController()
            signvc.signHandler = { url in
                wf.model?.picture = url
                wf.actionHandler(wf.model)
            }
            UIViewController.topVC?.present(signvc, animated: true)
        }
        return sign
    }()
}
