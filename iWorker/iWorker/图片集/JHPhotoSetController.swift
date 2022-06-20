//
//  JHPhotoSetController.swift
//  iWorker
//
//  Created by boyer on 2022/6/9.
//

import Foundation
import JHBase
import UIKit
import SwiftyJSON
import MBProgressHUD

class JHPhotoSetController: JHPhotoBaseController {
    
    var dataArray:[JHPhotosModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func createView() {
        super.createView()
        navTitle = "图片设置"
        // 设置tableview
        tableView.register(PhotoCollectCell.self, forCellReuseIdentifier: "PhotoCollectCell")
        customView()
    }
    func customView() {
        headerView.frame.size.height = 80
        tableView.tableHeaderView = headerView
        
        navBar.addSubview(sortBtn)
        sortBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
    }
    lazy var sortBtn: UIButton = {
        let sortBtn = UIButton()
        sortBtn.setImage(.init(named: "sort"), for: .normal)
        sortBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            //TODO: 排序
            if wf.dataArray.count == 0 {
                //无数据，无法排序
                return
            }
            let sort = JHSortViewController()
            sort.dataArray = wf.dataArray
            wf.navigationController?.pushViewController(sort, animated: true)
        }
        return sortBtn
    }()
    
    lazy var headerView: UIView = {
        let addImgBtn = UIButton()
        addImgBtn.setImage(.init(named: "img"), for: .normal)
        addImgBtn.setTitle("添加图片", for: .normal)
        addImgBtn.layer.cornerRadius = 8
        addImgBtn.titleLabel?.font = .systemFont(ofSize: 16)
        addImgBtn.backgroundColor = .k428BFE
        addImgBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        addImgBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            //TODO: 添加图片
            let add = JHPhotoAddController()
            add.type = 0
            add.storeId = wf.storeId
            wf.navigationController?.pushViewController(add, animated: true)
        }
        let addImgsBtn = UIButton()
        addImgsBtn.setImage(.init(named: "imgarr"), for: .normal)
        addImgsBtn.setTitle("添加图片集", for: .normal)
        addImgsBtn.layer.cornerRadius = 8
        addImgsBtn.titleLabel?.font = .systemFont(ofSize: 16)
        addImgsBtn.backgroundColor = .k428BFE
        addImgsBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        addImgsBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            //TODO: 添加图集
            let addCollect = JHPhotoAddCollectController()
            addCollect.type = 2
            addCollect.storeId = wf.storeId
            wf.navigationController?.pushViewController(addCollect, animated: true)
        }
        let header = UIView()
        header.addSubviews([addImgBtn,addImgsBtn])
        addImgBtn.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        addImgsBtn.snp.makeConstraints { make in
            make.left.equalTo(addImgBtn.snp.right).offset(50)
            make.right.equalTo(-30)
            make.size.equalTo(addImgBtn)
            make.centerY.equalToSuperview()
        }
        return header
    }()
}

extension JHPhotoSetController
{
    override func loadData() {
        let param:[String:Any] = ["StoreId":storeId,
                                  "PageIndex":pageIndex,
                                  "PageSize":20,
                                  ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/GetStoreBrandPub")
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
    
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCollectCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCollectCell") as! PhotoCollectCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        guard let picsId = model.brandPubID else { return }
        if !model.isPicList { return }
        let picsVC = JHPhotoNewController()
        picsVC.picsId = picsId
        navigationController?.pushViewController(picsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: 删除图集/图片
        let model = dataArray[indexPath.row]
        let param:[String:Any] = ["BrandPubUrlId":model.brandPubID!]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/DelStoreBrandPub")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            let msg = json["Message"].string
            if result {
                weakSelf.dataArray.remove(at: indexPath.row)
                weakSelf.tableView.reloadData()
            }
            //MBProgressHUD.displayError(msg)
        }
    }
}
