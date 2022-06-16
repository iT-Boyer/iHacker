//
//  PhotoHomeController.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import UIKit
import JHBase
import MBProgressHUD
import SwiftyJSON

class PhotoHomeController: JHPhotoBaseController {
    
    var dataArray:[StoreAmbientModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createView() {
        super.createView()
        // 设置tableview
        tableView.register(PhotoHomeCell.self, forCellReuseIdentifier: "PhotoHomeCell")
        typeControl.frame.size.height = 40
        tableView.tableHeaderView = typeControl
        
        //导航bar
        navBar.addSubviews([titleControl,rightView])
        titleControl.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
        }
    }
    
    lazy var titleControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["图片", "视频"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = .k2CD773
        segment.backgroundColor = .white
        segment.layer.borderColor = UIColor.k2CD773.cgColor
        segment.layer.borderWidth = 0.5
        let normal:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2CD773]
        let selected:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.white]
        segment.setTitleTextAttributes(normal, for: .normal)
        segment.setTitleTextAttributes(selected, for: .selected)
        let normalColor = UIImage(color: .white, size: CGSize(width: 1.0, height: 1.0))
        let selectedColor = UIImage(color: .k2CD773, size: CGSize(width: 1.0, height: 1.0))
        segment.setBackgroundImage(normalColor, for: .normal, barMetrics: .default)
        segment.setBackgroundImage(selectedColor, for: .selected, barMetrics: .default)
        segment.setBackgroundImage(selectedColor, for: .highlighted, barMetrics: .default)
        let clear = UIImage(color: .clear, size: CGSize(width: 0, height: 0))
        segment.setDividerImage(clear, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.addTarget(self, action: #selector(titleControlChange(_ :)), for: .valueChanged)
        return segment
    }()
    
    lazy var typeControl: JHSegmentedControl = {
        // 设置字体样式
        let normal:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2F3856,
                                                   .font:UIFont.systemFont(ofSize: 14)]
        let selected:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2CD773,
                                                     .font:UIFont.systemFont(ofSize: 16, weight: .bold)]
        
        let segment = JHSegmentedControl(items: ["获得荣誉", "环境图片"],normal: normal,selected:selected)
        //添加
        segment.addBottomline()
        segment.line.snp.updateConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width/2 - 40)
        }
        segment.addTarget(self, action: #selector(typeControlChange(_ :)), for: .valueChanged)
        return segment
    }()
    
    
    func titleControlChange(_ segmented: UISegmentedControl) {
        //TODO: 图片 视频 分类
        if segmented.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            hideEmptyView()
        }else{
            tableView.isHidden = true
            showNoDataView(view, tipMsg: "敬请期待")
            emptyView.frame = CGRect(x: 0, y: navBar.frame.maxY, width: kScreenWidth, height: kScreenHeight - navBar.frame.maxY)
        }
    }
    func typeControlChange(_ segmented: JHSegmentedControl) {
        //TODO: 获得荣誉, 环境图片 分类
        segmented.animateLine()
        pageIndex = 1
        loadData()
    }
    lazy var rightView: UIView = {
        let right = UIView()
        let upbtn = UIButton()
        upbtn.setImage(.init(named:"upload"), for: .normal)
        upbtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 新增 0: 图片 1:视频
            if wf.typeControl.selectedSegmentIndex == 0{
                let add = JHPhotoRecommendController()
                add.storeId = wf.storeId
                wf.navigationController?.pushViewController(add, animated: true)
            }else{
                let handler = JHHandlePictureViewController()
                handler.storeId = wf.storeId
                wf.navigationController?.pushViewController(handler, animated: true)
            }
        }
        let setbtn = UIButton()
        setbtn.setImage(.init(named: "set"), for: .normal)
        setbtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 设置
            let setvc = JHPhotoSetController()
            wf.navigationController?.pushViewController(setvc, animated: true)
        }
        
        right.addSubviews([upbtn,setbtn])
        
        upbtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.left.centerY.equalToSuperview()
        }
        
        setbtn.snp.makeConstraints { make in
            make.size.equalTo(upbtn)
            make.left.equalTo(upbtn.snp.right).offset(10)
            make.right.centerY.equalToSuperview()
        }
        return right
    }()
}

extension PhotoHomeController
{
    override func loadData() {
        super.loadData()
        let type = typeControl.selectedSegmentIndex == 0 ? 1:2
        let param:[String:Any] = ["StoreId":storeId,
                                  "Type":type,
                                  "PageIndex":pageIndex,
                                  "PageSize":20,
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
                guard let rawData = try? json["Data"].rawData() else {return}
                weakSelf.totalCount = json["totalCount"].intValue
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
                }else{
                    weakSelf.pageIndex = 1
                    weakSelf.showNoDataView()//showCustomNoDataView()
                    weakSelf.emptyView.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 500)
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
        let cell:PhotoHomeCell = tableView.dequeueReusableCell(withIdentifier: "PhotoHomeCell") as! PhotoHomeCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: 删除环境/菜品
        let model = dataArray[indexPath.row]
        let param:[String:Any] = ["AmbientId":model.ambientID!]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/DelAmbient")
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
