//
//  JHPhotoAddController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

/// 添加图片/图集
class JHPhotoAddController: JHPhotoBaseController {

    /// 1:图集 2:添加图集
    var type = 0
    var picsId = "00000000-0000-0000-0000-000000000000"
    var dataArray:[StoreAmbientModel] = []
    
    var addAmbient: AddambientM? {
        //TODO: 向图片集中添加图片
        var addAmbient = AddambientM()
        addAmbient.storeId = storeId
        if type == 0 {
            //添加特色菜
            addAmbient.isPicList = "0"
            addAmbient.type = "1"
        }else{ //向图片集中添加图片
            addAmbient.isPicList = "1"
            addAmbient.brandPubId = picsId
        }
        addAmbient.ambientList = dataArray.compactMap{ item -> AmbientModel? in
            let model = AmbientModel(ambientDesc: item.ambientDesc, ambientUrl: item.ambientURL)
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
        navTitle = "添加图片"
        
        tableView.register(PhotoAddCell.self, forCellReuseIdentifier: "PhotoAddCell")
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
    }
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.setTitle("确定", for: .normal)
//        btn.backgroundColor = .k42DA7F
        btn.setBackgroundImage(UIImage(color: .k42DA7F, size: CGSize(width: 1, height: 1)), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            wf.addAction()
        }
        return btn
    }()
}

extension JHPhotoAddController
{
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoAddCell = tableView.dequeueReusableCell(withIdentifier: "PhotoAddCell") as! PhotoAddCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:StoreAmbientModel = dataArray[indexPath.row]
        dataArray = dataArray.map{ item in
            var mm = item
            if model.ambientID == item.ambientID
            {
                mm.selected = !model.selected
            }
            return mm
        }
        bottomBtn.isEnabled = dataArray.filter{ $0.selected }.count > 0
        tableView.reloadData()
    }
    
    
    func addAction() {
        guard let model = addAmbient else {
            return
        }
        let param = model.toParams()
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/SubmitBrandPub")
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
                weakSelf.backBtnClicked(UIButton())
            }else{
                let msg = json["Message"].stringValue
                //MBProgressHUD.displayError(msg)
            }
        }
    }
    
    override func loadData() {
        let param:[String:Any] = ["StoreId":storeId,
                                  "Type": 0,
                                  "PageIndex":pageIndex,
                                  "PageSize":20
        ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/GetStoreAmbient")
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
                if json["Data"].isEmpty {
                    return
                }
                let rawData = try! json["Data"].rawData()
                weakSelf.totalCount = json["TotalCount"].intValue
                guard let photos:[StoreAmbientModel] =  StoreAmbientModel.parsed(data: rawData) else { return }
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
                    weakSelf.bottomBtn.snp.updateConstraints { make in
                        make.height.equalTo(44)
                    }
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
