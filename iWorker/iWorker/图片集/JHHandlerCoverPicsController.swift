//
//  JHHandlerCoverPictureController.swift
//  iWorker
//
//  Created by boyer on 2022/6/15.
//

import UIKit
import JHBase
import Alamofire
import SwiftyJSON
import MBProgressHUD

class JHHandlerCoverPicsController: JHPhotoBaseController {
    
    var picsId = "00000000-0000-0000-0000-000000000000"
    var dataArray:[StoreAmbientModel] = []
    var handler:((StoreAmbientModel)->Void) = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 调用图库
        callImages(imageCount: 1)
        var model = StoreAmbientModel()
        model.ambientURL = "https://upload.jianshu.io/users/upload_avatars/2456771/d9dc05b91093.jpg"
        dataArray = [model]
        tableView.reloadData()
    }
    
    override func createView() {
        super.createView()
        navTitle = "设置封面"
        tableView.register(PhotoEditCell.self, forCellReuseIdentifier: "PhotoEditCell")
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
    }
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setBackgroundImage(UIImage(color: .k42DA7F, size: CGSize(width: 1, height: 1)), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            wf.sureAction()
        }
        return btn
    }()
    
    func callImages(imageCount:Int) {
        let paraDic = ["tkCamareType":0,
                       "canSelectImageCount":imageCount,
                       "sourceType":0,
                       "UIViewController":self] as [String : Any]
        /**
         JHRoutingComponent.openURL(GETIMAGE, withParameter: paraDic) { [weak self] resultDic in
             guard let self = self else { return }
             guard let resultDic = resultDic as? [String: Any] else { return }
             guard let array = resultDic["data"] as? [[String: Any]] else { return }
             guard let imageDic = array.first else { return }
             var image = imageDic["originalImage"] as? UIImage
             if image == nil, let thImage = imageDic["thumbnails"] as? UIImage {
                 image = thImage
             }
             
             OperationQueue.main.addOperation {
                 JHLiveBaseRequest.uploadImage(image, showLoading: true) { fileUrl in
                     OperationQueue.main.addOperation {
                         if let url = URL(string: fileUrl) {
                             self.photo.kf.setImage(with: url, for: .normal, placeholder: .init(named: "JHShortVideoResource.bundle/img_placehodler"))
                             self.photoUrl = fileUrl!
                         }
                     }
                 }
             }
         }
         */
    }
    
    func uploadImage(image:UIImage) {
        var domainKey = "api_host_upload"
        if JHBaseDomain.environment.count == 0 {
            domainKey = "api_host_upload_up"
        }
        let serverUrl = JHBaseDomain.fullURL(with: domainKey, path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
        let headers:HTTPHeaders = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==",
                                   "Content-Type": "form/data"]
//        MBProgressHUD.showText("", animated: true)
        AF.upload(multipartFormData: { multipartFormData in
            // params相关入参，不影响图片正常上传
            let imageData = image.compressedData()
            if let data = imageData{
                multipartFormData.append(data, withName: "FileDataFromPhone", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
        }, to: serverUrl, method: .post, headers: headers).responseJSON { response in
            
//            MBProgressHUD.hideHUDanimated(true)
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
//                self.submitPhoto("", url: fileUrl)
            }
        }
    }
}



extension JHHandlerCoverPicsController
{
    func sureAction() {
        guard let model = dataArray.first, model.ambientDesc != nil else {
            VCTools.toast("请编写图片描述")
            return
        }
        
        if picsId == "00000000-0000-0000-0000-000000000000" {
            //TODO: 设置图片集封面
            handler(model)
        }else{
            //TODO: 更新图片集封面
            let param = ["BrandPubUrlId":picsId, "ImgUrl":model.ambientURL, "ImgDes":model.ambientDesc]
            let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/UptStoreBrandPubCover")
            let hud = MBProgressHUD.showAdded(to:view, animated: true)
            hud.removeFromSuperViewOnHide = true
            let request = JN.post(urlStr, parameters: param as [String : Any], headers: nil)
            request.response {[weak self] response in
                hud.hide(animated: true)
                guard let weakSelf = self else { return }
                weakSelf.tableView.es.stopLoadingMore()
                weakSelf.tableView.es.stopPullToRefresh()
                guard let data = response.data else {
                    //                MBProgressHUD.displayError(kInternetError)
                    return
                }
                let json = JSON(data)
                let result = json["IsSuccess"].boolValue
                if result {
                    
                    weakSelf.backBtnClicked(UIButton())
                }else{
                    let msg = "上传失败，请重新上传"
                    //MBProgressHUD.displayError(msg)
                }
            }
        }
    }
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoEditCell = tableView.dequeueReusableCell(withIdentifier: "PhotoEditCell") as! PhotoEditCell
        cell.model = dataArray[indexPath.row]
        cell.updateBlock = {[weak self] mm in
            guard let wf = self else {return}
            wf.dataArray[indexPath.row] = mm
        }
        return cell
    }
}
