//
//  JHMornUpPhotoController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import UIKit
import JHBase
import Alamofire
import SwiftyJSON
import AVFoundation


class JHMornUpPhotoController: JHMornCameraController {

    var preView:UIImageView!
    var checkArr:[JHMornUploadModel] = []
    weak var delegate:JHMornUploadPhotoDelegate?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createView() {
        let resetBtn = UIButton()
        resetBtn.backgroundColor = UIColor(white: 0, alpha: 0.6)
        resetBtn.layer.masksToBounds = true
        resetBtn.layer.cornerRadius = 22.5
        resetBtn.setTitleColor(.white, for: .normal)
        resetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        resetBtn.setTitle("重新拍摄", for: .normal)
        resetBtn.addTarget(self, action: #selector(reCamraAction), for: .touchDown)
        
        let submitBtn = UIButton()
        submitBtn.backgroundColor = UIColor(hexString: "07C58F")
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 22.5
        submitBtn.titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        submitBtn.setTitle("确定", for: .normal)
        submitBtn.addTarget(self, action: #selector(upload), for: .touchDown)
        
        let photo = UIImageView()
        preView = photo
        photo.backgroundColor = .black
        photo.isUserInteractionEnabled = true
        photo.contentMode = .scaleAspectFit
        
        photo.addSubview(resetBtn)
        photo.addSubview(submitBtn)
        view?.addSubview(photo)
        
        photo.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        resetBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 110, height: 45))
            make.left.equalTo(25)
            make.bottom.equalTo((-25))
        }
        
        submitBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-25)
            make.right.equalTo(-25)
            make.height.equalTo(45)
            make.left.equalTo(resetBtn.snp.right).offset(15)
        }
        super.createView()
    }
}

extension JHMornUpPhotoController
{
    func submitPhoto(_ local:String,url:String) {
        //
        let imgModel = self.checkArr[self.currentIndex]
        imgModel.localPath = local
        imgModel.url = url
        imgModel.image = self.preView.image
        
        if self.currentIndex == self.checkArr.count - 1 {
            self.navigationController?.popToRootViewController(animated: true)
            //https://stackoverflow.com/questions/24167791/what-is-the-swift-equivalent-of-respondstoselector
            self.delegate?.afterUpload(self.checkArr, complated: true)
        }else{
            nextStepPhoto()
        }
    }
    
    func nextStepPhoto() {
        self.view.sendSubviewToBack(self.preView)
        self.changeDeviceAction()
        self.currentIndex = self.currentIndex + 1
        let imgModel = self.checkArr[self.currentIndex]
        self.refresh(imgModel.tip, icon: imgModel.icon)
    }
    
    @objc func reCamraAction()
    {
        self.view.sendSubviewToBack(self.preView)
    }
    @objc
    func upload() {
        let serverUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
        let headers:HTTPHeaders = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==","Content-Type":"form/data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            // params相关入参，不影响图片正常上传
            let imageData = self.preView.image?.compressedData()
            if let data = imageData{
                multipartFormData.append(data, withName: "FileDataFromPhone", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
        }, to: serverUrl, method: .post, headers: headers).responseJSON { response in
            
            if let err = response.error{
                print(err)
                return
            }
            
            let json = response.data
            
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                let filePath = jsonObject["FilePath"].string
                let fileUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.UI/FileManage/GetFile?fileURL=\(filePath!)")
                self.submitPhoto("", url: fileUrl)
            }
        }
    }
}

extension JHMornUpPhotoController
{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error == nil {
            let data = photo.fileDataRepresentation()
            self.preView.image = UIImage(data: data!)
            view.bringSubviewToFront(self.preView)
        }
    }
}
