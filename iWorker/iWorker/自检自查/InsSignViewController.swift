//
//  InsSignViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import Alamofire
import SwiftyJSON
import MBProgressHUD
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
            
//            UIImage *imageRight = [UIImage imageWithCGImage:signImage.CGImage scale:1.0 orientation:UIImageOrientationLeft];
            guard let cgImg = signatureImage.cgImage else {return}
            let imageRight = UIImage.init(cgImage: cgImg, scale: 1.0, orientation: .left)
            uploadImage(image: imageRight)
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
    
    func uploadImage(image:UIImage) {
        var domainKey = "api_host_upload"
        if JHBaseDomain.environment.count == 0 {
            domainKey = "api_host_upload_up"
        }
        let serverUrl = JHBaseDomain.fullURL(with: domainKey, path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
        let headers:HTTPHeaders = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==",
                                   "Content-Type": "form/data"]
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        AF.upload(multipartFormData: { multipartFormData in
            // params相关入参，不影响图片正常上传
            let imageData = image.compressedData()
            if let data = imageData{
                multipartFormData.append(data, withName: "FileDataFromPhone", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
        }, to: serverUrl, method: .post, headers: headers).responseJSON {[weak self] response in
            guard let wf = self else { return }
            if let err = response.error{
//                MBProgressHUD.displayError(err.errorDescription!)
                return
            }
            
            let json = response.data
                
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                let filePath = jsonObject["FilePath"].string
                let fileUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.UI/FileManage/GetFile?fileURL=\(filePath!)")
                OperationQueue.main.addOperation {
                    hud.hide(animated: true)
                    // 上传任务结束之后，移除元素
                    wf.signHandler(fileUrl)
                    wf.backBtnClicked(UIButton())
                }
            }
        }
    }
}
