//
//  JHMornCameraController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import JHBase
import UIKit

class JHMornCameraController: JHBaseNavVC {
    
    var bgView:UIImageView!
    var tipLabel:UILabel!
    var iconView:UIImageView!
    var ensureBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "晨检拍照"
        createView()
    }
    
    func createView() {
        bgView = UIImageView()
        tipLabel = UILabel()
        tipLabel.textAlignment = .center
        tipLabel.text = "请进行收不卫生拍摄"
        tipLabel.backgroundColor = UIColor(white: 0, alpha: 0.6)
        tipLabel.layer.masksToBounds = true
        tipLabel.layer.cornerRadius = 20
        tipLabel.textColor = .white
        iconView = UIImageView(image: UIImage(named: "morincheckhander"))
        ensureBtn = UIButton()
        ensureBtn.setImage(UIImage(named: "morncheckcamerabtn"), for: .normal)
        ensureBtn.addTarget(self, action: Selector(""), for: .touchDown)
        
        view.addSubview(bgView)
        view.addSubview(tipLabel)
        view.addSubview(iconView)
        view.addSubview(ensureBtn)
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 220, height: 40))
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 295, height: 315))
        }
        
        ensureBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kEmptyBottomHeight)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
    }
}
