//
//  JHSortViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHSortViewController: JHPhotoBaseController {

    var dataArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        navTitle = "图片排序"
        tableView.isEditing = true
        tableView.register(PhotoCollectCell.self, forCellReuseIdentifier: "PhotoCollectCell")
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
        btn.setTitle("确定", for: .normal)
//        btn.backgroundColor = .k42DA7F
        btn.setBackgroundImage(UIImage(color: .k42DA7F, size: CGSize(width: 1, height: 1)), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            wf.sortAction()
        }
        return btn
    }()
}

// tableView
extension JHSortViewController
{
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCollectCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCollectCell") as! PhotoCollectCell
        cell.model = dataArray[indexPath.row] as? JHPhotosModel
        return cell
    }
    // 隐藏右侧删除按钮
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    // 内容居左空间，不计入删除按钮宽度
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataArray.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)
        tableView.reloadData()
    }
}

// loadData
extension JHSortViewController
{
    func sortAction() {
        guard let arr = dataArray as? [JHPhotosModel] else {return}
        let iDs = arr.compactMap { model -> String? in
            return model.brandPubID
        }
        let param:[String:Any] = ["BrandPubIds":iDs]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/UptBrandPubSort")
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
//                MBProgressHUD.displayError("上传成功")
                weakSelf.backBtnClicked(UIButton())
            }else{
//                MBProgressHUD.displayError("上传失败，请重新上传")
            }
        }
    }
    
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
                if json["Data"].isEmpty {
                    return
                }
                let rawData = try! json["Data"].rawData()
                weakSelf.totalCount = json["TotalCount"].intValue
                guard let photos:[JHPhotosModel] =  JHPhotosModel.parsed(data: rawData) else { return }
                if weakSelf.pageIndex == 1 {
                    weakSelf.dataArray.removeAllObjects()
                }
                if photos.count > 0 {
                    if photos.count < 20 {
                        weakSelf.tableView.es.noticeNoMoreData()
                    }else{
                        weakSelf.tableView.es.resetNoMoreData()
                    }
                    weakSelf.dataArray.addObjects(from: photos)
                }
                
                if weakSelf.dataArray.count > 0 {
                    weakSelf.tableView.reloadData()
                    weakSelf.pageIndex += 1
                    weakSelf.bottomBtn.snp.updateConstraints { make in
                        make.height.equalTo(44)
                    }
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
