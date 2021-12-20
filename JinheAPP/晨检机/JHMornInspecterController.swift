//
//  JHMornInspecterController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import JHBase
import UIKit

fileprivate extension Selector {
    static let cameraClick = #selector(JHMornInspecterController.startCamera(_:))
//    static let cyanButtonClick = #selector(ViewController.cyanButtonClick)
}


class JHMornInspecterController: JHBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "晨检机"
        createView()
    }
}

extension JHMornInspecterController
{
    func createView() {
        let title = UILabel()
        title.text = "请进行人脸识别"
        title.textColor = UIColor.k2F3856
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let imageView = UIImageView(image: UIImage(named: "mornfaceimage"))
        let faceBtn = UIButton()
        faceBtn.layer.cornerRadius = 22.5
        faceBtn.layer.masksToBounds = true
        faceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        faceBtn.setTitle("去识别", for: .normal)
        faceBtn.backgroundColor = UIColor.initWithHex("07C58F")
        faceBtn.addTarget(self, action: .cameraClick, for: .touchDown)
        
        self.view.addSubview(title)
        self.view.addSubview(imageView)
        self.view.addSubview(faceBtn)
        
        title.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.navBar.snp.bottom).offset(60)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 300))
        }
        
        faceBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kEmptyBottomHeight)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(25)
        }
        
        
    }
    
    @objc func startCamera(_ btn:UIButton) {
        print("去识别...")
    }
}
