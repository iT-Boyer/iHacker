//
//  InsSignViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import YPDrawSignature

class InsSignViewController: JHBaseNavVC {

    var signHandler:(String)->Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
    }
    
    @objc func saveDraw() {
        if let signatureImage = self.drawView.getSignature(scale: 10) {
            
            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            
            self.drawView.clear()
        }
    }
    
    @objc func clear() {
        drawView.clear()
    }
    
    func createView() {
        navTitle = "签字"
        
        let backBtn = UIButton()
        backBtn.setTitle("返回", for: .normal)
        backBtn.setTitleColor(.black, for: .normal)
        
        view.addSubviews([drawView, saveBtn, clearBtn, backBtn])
        drawView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(drawView.snp.bottom)
            make.size.equalTo(CGSize(width: 40, height: 30))
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.top.equalTo(drawView.snp.bottom)
            make.size.equalTo(CGSize(width: 40, height: 30))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(drawView.snp.bottom)
            make.size.equalTo(CGSize(width: 40, height: 30))
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var drawView: YPDrawSignatureView = {
        let draw = YPDrawSignatureView()
        draw.delegate = self
        return draw
    }()
    
    lazy var saveBtn: UIButton = {
        let save = UIButton()
        save.setTitle("保存", for: .normal)
        save.setTitleColor(.black, for: .normal)
        save.addTarget(self, action: #selector(saveDraw), for: .touchDown)
        return save
    }()
    
    lazy var clearBtn: UIButton = {
        let save = UIButton()
        save.setTitle("擦除", for: .normal)
        save.addTarget(self, action: #selector(clear), for: .touchDown)
        return save
    }()
}

extension InsSignViewController:YPSignatureDelegate
{
    func didStart(_ view: YPDrawSignatureView) {
        
    }
    
    func didFinish(_ view: YPDrawSignatureView) {
        
    }
}
