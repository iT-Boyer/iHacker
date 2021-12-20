//
//  JHMornCameraController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import JHBase
import UIKit
import AVFoundation

class JHMornCameraController: JHBaseNavVC {
    
    var bgView:UIImageView!
    var tipLabel:UILabel!
    var iconView:UIImageView!
    var ensureBtn:UIButton!
    
    //相机属性
    var imageOutput:AVCapturePhotoOutput!
    var imageInput:AVCaptureDeviceInput!
    var session:AVCaptureSession!
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    
    public var photo:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "晨检拍照"
        createView()
        customCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
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
        ensureBtn.addTarget(self, action: #selector(takePhtoClick), for: .touchDown)
        
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
    @objc func takePhtoClick()
    {
        let set = AVCapturePhotoSettings()
        imageOutput.capturePhoto(with: set, delegate: self)
    }
    
    func refresh(_ tip:String, icon:String) {
        iconView.image = UIImage(named: icon)
        tipLabel.text = tip
    }
}

// 自定义拍照页面
extension JHMornCameraController
{
    func customCamera() {
        //
        session = AVCaptureSession()
        if session.canSetSessionPreset(.hd1280x720) {
            session.canSetSessionPreset(.hd1280x720)
        }
        let device = AVCaptureDevice.default(for: .video)
        imageInput = try! AVCaptureDeviceInput(device: device!)
        
        if session.canAddInput(imageInput) {
            session.addInput(imageInput)
        }
        
        imageOutput = AVCapturePhotoOutput()
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
            let connection = imageOutput.connection(with: .video)
            if connection!.isVideoStabilizationSupported {
                connection?.preferredVideoStabilizationMode = .cinematic
            }
        }
        imageOutput.connections.last?.videoOrientation = .portrait
        session.startRunning()
        
        //拍照场景layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        bgView.layoutIfNeeded()
        previewLayer.frame = bgView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        bgView.layer.addSublayer(previewLayer)
    }
}

//MARK: - api
extension JHMornCameraController:AVCapturePhotoCaptureDelegate
{
    public func changeDeviceAction() {
        if session == nil {
            return
        }
        if session.isRunning {
            session.startRunning()
        }
        session.beginConfiguration()
        
        //
        let curDevice = imageInput.device
        var toChangeDevice:AVCaptureDevice!
        if curDevice.position == .back {
            toChangeDevice = cameraWithPosition(position: .front)
        }else{
            toChangeDevice = cameraWithPosition(position: .back)
        }
    }
    
    func cameraWithPosition(position:AVCaptureDevice.Position)->AVCaptureDevice?{
        let devices = AVCaptureDevice.devices(for: .video)
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            let data = photo.fileDataRepresentation()
            self.photo = UIImage(data: data!)
        }
    }
    
}
