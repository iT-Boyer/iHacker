//
//  JHPhotoDetailController.swift
//  iWorker
//
//  Created by boyer on 2022/6/16.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHPhotoDetailController: JHBaseNavVC {

    var storeId = "00000000-0000-0000-0000-000000000000"
    var pageIndex = 1
    var dataArray:[StoreAmbientModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
        loadData()
    }
    
    func createView() {
        navTitle = "品牌宣传"
        view.backgroundColor = .white
            
        view.addSubviews([typeControl, collectionView])
        
        typeControl.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(typeControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(PhotoDetailCollectionView.self, forCellWithReuseIdentifier: "PhotoDetailCollectionView")
        collection.es.addPullToRefresh { [weak self] in
            guard let wf = self else{return}
            /// 在这里做刷新相关事件
            wf.pageIndex = 1
            wf.loadData()
        }
        
        /// 在这里做加载更多相关事件
        collection.es.addInfiniteScrolling { [weak self] in
            guard let wf = self else{return}
            wf.loadData()
        }
        return collection
    }()
    
    lazy var typeControl: JHSegmentedControl = {
        // 设置字体样式
        let normal:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2F3856,
                                                   .font:UIFont.systemFont(ofSize: 14)]
        let selected:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2CD773,
                                                     .font:UIFont.systemFont(ofSize: 16, weight: .bold)]
        
        let segment = JHSegmentedControl(items: ["环境图片", "获得荣誉"],normal: normal,selected:selected)
        //添加
        segment.addBottomline()
        segment.line.snp.updateConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width/2 - 40)
        }
        segment.addTarget(self, action: #selector(typeControlChange(_ :)), for: .valueChanged)
        return segment
    }()
    
    func typeControlChange(_ segmented: JHSegmentedControl) {
        //TODO: 获得荣誉, 环境图片 分类
        segmented.animateLine()
        pageIndex = 1
        loadData()
    }
}

extension JHPhotoDetailController
{
    func loadData() {
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
            weakSelf.collectionView.es.stopLoadingMore()
            weakSelf.collectionView.es.stopPullToRefresh()
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                guard let rawData = try? json["Data"].rawData() else {return}
//                weakSelf.totalCount = json["totalCount"].intValue
                guard let photos:[StoreAmbientModel] =  StoreAmbientModel.parsed(data: rawData) else { return }
                if weakSelf.pageIndex == 1 {
                    weakSelf.dataArray.removeAll()
                }
                if photos.count > 0 {
                    if photos.count < 20 {
                        weakSelf.collectionView.es.noticeNoMoreData()
                    }else{
                        weakSelf.collectionView.es.resetNoMoreData()
                    }
                    weakSelf.dataArray += photos
                }
                
                if weakSelf.dataArray.count > 0 {
                    weakSelf.collectionView.reloadData()
                    weakSelf.pageIndex += 1
                    weakSelf.hideEmptyView()
                }else{
                    weakSelf.pageIndex = 1
                    weakSelf.showNoDataView()
                    weakSelf.emptyView.frame = CGRect(x: 0, y: weakSelf.navBar.frame.maxY + 40, width: UIScreen.main.bounds.width, height: 500)
                    weakSelf.collectionView.reloadData()
                }
            }else{
                let msg = json["message"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}


extension JHPhotoDetailController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCollectionView", for: indexPath) as? PhotoDetailCollectionView else { return UICollectionViewCell()}
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgArray = dataArray.compactMap { model -> String? in
            model.ambientURL
        }
        let params:[String : Any] = ["dataArray":imgArray, "selectedIndex":indexPath.row]
//        JHRoutingComponent.openUrl
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    // 返回cell的尺寸大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (kScreenWidth - 35)/2
        return CGSize(width: width, height: width)
    }
    // 返回cell之间行间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        11
    }
    
    // 返回cell之间列间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 11, bottom: 0, right: 11)
    }
}
