//
//  UITools.swift
//  iWorker
//
//  Created by boyer on 2022/3/24.
//

import Foundation
import JHBase
import MBProgressHUD
import TZImagePickerController
import UIKit
import Alamofire
import SwiftyJSON

/** 自定义金和长文本提示框
 let hub = MBProgressHUD.showAdded(to: (UIViewController.topVC?.view)!, animated: true)
 hub.mode = MBProgressHUDMode(5)
 hub.detailsLabel.text = msg
 hub.hide(true, afterDelay: 5.0)
 */
class VCTools: NSObject {
        
    var camerahandler:(JHCameraModel)->Void = {_ in}
    lazy var picker: TZImagePickerController = {
        let pp = TZImagePickerController()//TZImagePickerController(maxImagesCount: count, delegate: nil)
        return pp
    }()
    static func toast(_ msg:String) {
        
        guard let topView = UIViewController.topVC?.view else {
            return
        }
        let hub = MBProgressHUD.showAdded(to: topView, animated: true)
        hub.mode = .text
        hub.detailsLabel.text = msg
        hub.offset = .init(x: 0, y: MBProgressMaxOffset)
        hub.hide(animated: true, afterDelay: 3)
    }
    
    func showCamera(count:Int, handler:@escaping (JHCameraModel)->Void) {
        camerahandler = handler
        picker.maxImagesCount = count
        picker.didFinishPickingPhotosHandle = { [weak self] images, assets, isSelectOriginalPhoto in
            //TODO: 选择图片结束
            guard let wf = self, let photos = images else { return }
            wf.upload(photos)
        }
        picker.modalPresentationStyle = .fullScreen
        UIViewController.topVC?.present(picker, animated: true)
    }
    func upload(_ images:[UIImage]) {
        var photos = images
        guard let imgData = images.first else { return }
        var domainKey = "api_host_upload"
        if JHBaseDomain.environment.count == 0 {
            domainKey = "api_host_upload_up"
        }
        let serverUrl = JHBaseDomain.fullURL(with: domainKey, path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
        let headers:HTTPHeaders = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==",
                                   "Content-Type": "form/data"]
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.removeFromSuperViewOnHide = true
        AF.upload(multipartFormData: { multipartFormData in
            // params相关入参，不影响图片正常上传
            let imageData = imgData.compressedData()
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
                    // 上传任务结束之后，移除元素
                    photos.removeFirst()
                    let model = JHCameraModel(url: fileUrl)
                    wf.camerahandler(model)
                    if photos.isEmpty{
                        hud.hide(animated: true)
                    }else{
                        //继续上传
                        wf.upload(photos)
                    }
                }
            }
        }
        
    }
}
