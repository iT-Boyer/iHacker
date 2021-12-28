//
//  JHMornUpPhotoController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import UIKit
import JHBase
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
        resetBtn.addTarget(self, action: Selector(""), for: .touchDown)
        
        let submitBtn = UIButton()
        submitBtn.backgroundColor = UIColor(hexString: "07C58F")
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 22.5
        submitBtn.titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        submitBtn.setTitle("确定", for: .normal)
        submitBtn.addTarget(self, action: #selector(JHMornInspecterController.startCamera(_:)), for: .touchDown)
        
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
    
    func reCamraAction()
    {
        self.view.sendSubviewToBack(self.preView)
    }
    
    func upload() {
        
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
