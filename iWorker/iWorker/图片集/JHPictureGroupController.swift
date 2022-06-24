//
//  JHPictureGroupController.swift
//  iWorker
//
//  Created by boyer on 2022/6/16.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

///图片集列表
class JHPictureGroupController: JHPhotoBaseController {

    var picsId = "00000000-0000-0000-0000-000000000000"
    var dataArray:[JHPhotosModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func createView() {
        super.createView()
        tableView.register(PhotoCollectCell.self, forCellReuseIdentifier: "PhotoCollectCell")
    }

}

extension JHPictureGroupController
{
    
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCollectCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCollectCell") as! PhotoCollectCell
        var model = dataArray[indexPath.row]
        model.picTotal = totalCount
        cell.model = model
        cell.collectImageView.isUserInteractionEnabled = false
        cell.collectImageView.isHidden = indexPath.row > 0
        cell.iconView.isUserInteractionEnabled = indexPath.row > 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imgArray = dataArray.compactMap { model -> String? in
            model.picURL
        }
        let params:[String : Any] = ["dataArray":imgArray, "selectedIndex":indexPath.row]
        //TODO: 大图预览
//        JHRoutingComponent.openUrl
    }
    
    override func loadData() {
        super.loadData()
        let param:[String:Any] = ["BrandPubId":picsId,
                                  "PageIndex":pageIndex,
                                  "PageSize":20,
                                  ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/GetBrandPubDetail")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
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
                guard let rawData = try? json["Data"].rawData() else {return}
                weakSelf.totalCount = json["TotalCount"].intValue
                guard let photos:[JHPhotosModel] =  JHPhotosModel.parsed(data: rawData) else { return }
                if weakSelf.pageIndex == 1 {
                    weakSelf.dataArray.removeAll()
                }
                if photos.count > 0 {
                    if photos.count < 20 {
                        weakSelf.tableView.es.noticeNoMoreData()
                    }else{
                        weakSelf.tableView.es.resetNoMoreData()
                    }
                    weakSelf.dataArray += photos
                }
                
                if weakSelf.dataArray.count > 0 {
                    weakSelf.tableView.reloadData()
                    weakSelf.pageIndex += 1
                    weakSelf.hideEmptyView()
                }else{
                    weakSelf.pageIndex = 1
                    weakSelf.showNoDataView()
                    weakSelf.emptyView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 500)
                }
            }else{
                let msg = json["message"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
