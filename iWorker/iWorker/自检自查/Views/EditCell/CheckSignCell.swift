//
//  CheckSignCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import UIKit
import JHBase

class CheckSignCell: CheckEditBaseCell {

    override var model: CheckEditCellVM?{
        willSet{
            guard let new = newValue else { return }
            
            signView.kf.setImage(with: URL(string: new.picture), for: .normal, placeholder: UIImage(named: "Inspect签名占位"))
        }
    }
    
    override func updateUI() {
        iconView.image = .init(named: "Inspect签字")
        actionView.addSubview(signView)
        signView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 160, height: 75))
            make.left.top.bottom.equalToSuperview()
        }
    }
    
    lazy var signView: UIButton = {
        let sign = UIButton()
        sign.setImage(.init(named: ""), for: .normal)
        sign.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            if let mm = wf.model, mm.isDetail{
                //TODO: 大图预览
                
            }else{
                //TODO: 签名跳转
                let signvc = InsSignViewController()
                signvc.signHandler = { url in
                    wf.model?.picture = url
                    wf.actionHandler(wf.model)
                }
                signvc.modalPresentationStyle = .fullScreen
                UIViewController.topVC?.present(signvc, animated: true)
            }
        }
        return sign
    }()
}
