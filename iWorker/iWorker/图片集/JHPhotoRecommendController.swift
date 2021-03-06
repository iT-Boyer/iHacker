//
//  JHPhotoRecommendController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

/// 特色菜
class JHPhotoRecommendController: JHPhotoAddController {
    
    var recommendArray:[JHRecommendModel] = []
    
    override var addAmbient: AddambientM?{
        //TODO: 添加特色菜
        var addAmbient = AddambientM()
        addAmbient.storeId = storeId
        addAmbient.type = "1"
        addAmbient.isPicList = "0"
        addAmbient.brandPubId = "00000000-0000-0000-0000-000000000000"
        addAmbient.ambientList = recommendArray.compactMap{ item -> AmbientModel? in
            if !item.selected {return nil}
            let model = AmbientModel(ambientDesc: item.name, ambientUrl: item.imageURL)
            return model
        }
        return addAmbient
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        navTitle = "查看推荐菜"
        tableView.es.removeRefreshFooter()
        tableView.es.removeRefreshHeader()
    }
}

extension JHPhotoRecommendController
{
    override func numberOfRowsInSection() -> Int {
        recommendArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoAddCell = tableView.dequeueReusableCell(withIdentifier: "PhotoAddCell") as! PhotoAddCell
        cell.recommend = recommendArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:JHRecommendModel = recommendArray[indexPath.row]
        recommendArray = recommendArray.map{ item in
            var mm = item
            if model.businessRecommendID == item.businessRecommendID
            {
                mm.selected = !model.selected
            }
            return mm
        }
        bottomBtn.isEnabled = recommendArray.filter{ $0.selected }.count > 0
        tableView.reloadData()
    }
    override func addAction() {
        guard let model = addAmbient else {
            return
        }
        let param = model.toParams()
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/SubmitAmbient")
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
                NotificationCenter.default.post(name: .init(rawValue: "JHPhotoBase_refreshList"), object: nil)
                weakSelf.backBtnClicked(UIButton())
            }else{
                let msg = json["Message"].stringValue
                //MBProgressHUD.displayError(msg)
            }
        }
    }
    
    override func loadData() {
        let param:[String:Any] = ["storeId":storeId]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/StoreDetail/getRecommendInfo")
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
                guard let rawData = try? json["specialDishes"].rawData() else {return}
                guard let photos:[JHRecommendModel] =  JHRecommendModel.parsed(data: rawData) else { return }
                if photos.count > 0 {
                    weakSelf.recommendArray = photos
                    weakSelf.tableView.reloadData()
                    weakSelf.bottomBtn.snp.updateConstraints { make in
                        make.height.equalTo(44)
                    }
                }else{
                    weakSelf.showNoDataView()
                }
            }else{
                let msg = json["message"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
