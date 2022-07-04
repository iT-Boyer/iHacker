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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rect = CGSize(width: 40, height: 100)
        saveBtn.frame = CGRect(center: saveBtn.center, size: rect)
        clearBtn.frame = CGRect(center: clearBtn.center, size: rect)
        backBtn.frame = CGRect(center: backBtn.center, size: rect)
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
        
        navBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubviews([drawView, saveBtn, clearBtn, backBtn])
        drawView.snp.makeConstraints { make in
            make.top.equalTo(20 + kEmptyBottomHeight)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        let line = JHSquareView()
        drawView.addSubview(line)
        line.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(drawView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 40, height: 100))
            make.left.equalTo(20)
            make.bottom.equalTo(-kEmptyBottomHeight)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.top.equalTo(saveBtn.snp.top)
            make.size.equalTo(saveBtn)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-kEmptyBottomHeight)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(saveBtn.snp.top)
            make.size.equalTo(saveBtn)
            make.right.equalTo(-20)
            make.bottom.equalTo(-kEmptyBottomHeight)
        }
        
        view.layoutIfNeeded()
        line.drawDottedLine(line.bounds, 5, .red)
    }
    
    lazy var backBtn: UIButton = {
        let back = btnStyle()
        back.setTitle("返回", for: .normal)
        back.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.backBtnClicked(UIButton())
        }
        return back
    }()
    
    lazy var drawView: YPDrawSignatureView = {
        let draw = YPDrawSignatureView()
        draw.delegate = self
        draw.backgroundColor = .white
        return draw
    }()
    
    lazy var saveBtn: UIButton = {
        let save = btnStyle()
        save.setTitle("保存", for: .normal)
        save.setTitleColor(.black, for: .normal)
        save.addTarget(self, action: #selector(saveDraw), for: .touchDown)
        return save
    }()
    
    lazy var clearBtn: UIButton = {
        let btn = btnStyle()
        btn.setTitle("擦除", for: .normal)
        btn.addTarget(self, action: #selector(clear), for: .touchDown)
        return btn
    }()
    
    func btnStyle()->UIButton {
        let btn = UIButton()
        btn.setTitleColor(.k333333, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.kDDDDDD.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 18)
        btn.transform = CGAffineTransform(rotationAngle: Double.pi / 2)
        return btn
    }
}

extension InsSignViewController:YPSignatureDelegate
{
    func didStart(_ view: YPDrawSignatureView) {
        
    }
    
    func didFinish(_ view: YPDrawSignatureView) {
        
    }
}
