//
//  ReportUserMapController.swift
//  iWorker
//
//  Created by boyer on 2022/5/23.
//

import JHBase
import MapKit
import SwiftyJSON
import MBProgressHUD
import CloudKit

class ReportUserMapController: JHBaseNavVC {
    
    var userModel:ReportLastFootM!
    var keyword:String = ""
    var departmentId:String = ""
    var currentAnnotation = ReportUserAnnotation()
    var layoutId = ""
    
    var annotationArray:[ReportUserAnnotation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.isHidden = true
        //请求权限
        requestLocationMap()
        setRegion(latitude: 39.95, longitude: 116.36)
        if let smid = UserDefaults.standard.object(forKey: "ScoreManageId") as? String {
            if layoutId == "" {
                layoutId = smid
            }
        }
        createView()
        loadLastFootData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: NSNotification.Name("UIKeyboardWillShowNotification"), object: nil)
    }
    
    func createView() {
        view.addSubviews([mapView,filterView,filterBtn])
        mapView.snp.makeConstraints { make in
            make.top.bottom.left.centerX.equalToSuperview()
        }
        
        filterView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        filterBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(navBar.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.mapType = .standard
        map.userTrackingMode = .follow
        map.showsUserLocation = true
        map.register(ReportUserAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ReportUserAnnotationView")
        map.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserLocation")
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideInfoView(tap:)))
        map.addGestureRecognizer(tap)
        return map
    }()
    
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .init(white: 0, alpha: 0.5)
        lab.layer.cornerRadius = 9
        lab.layer.masksToBounds = true
        lab.font = .systemFont(ofSize: 12)
        lab.textAlignment = .center
        lab.textColor = .white
        view.addSubview(lab)
        lab.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(-20)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
        }
        return lab
    }()
    @objc
    func hideNumView() {
        self.numLab.isHidden = true
    }
    lazy var filterView: MapFilterBarView = {
        let view = MapFilterBarView(with: "请输入人员名称") {[weak self] data in
            //TODO: 选择人员业务
            guard let wf = self else{return}
            guard let model:ReportLastFootM = data else{
                wf.keyword = ""
                wf.loadLastFootData()
                return
            }
            wf.keyword = wf.filterView.searchBar.searchBar.text ?? ""
            wf.userModel = model
            let annotation = ReportUserAnnotation()
            annotation.title = model.location
            annotation.reportDate = model.reportDate
            annotation.userId = model.userID
            annotation.coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
            wf.selectUserAnnotation(annotation)
            wf.setRegion(latitude: model.latitude, longitude: model.longitude)
        } completed: {[weak self] in
            guard let wf = self else{return}
            wf.backBtnClicked(UIButton())
        }

        return view
    }()
    
    lazy var transitionDelegate: JHFilterTransitionDelegate = {
        let delegate = JHFilterTransitionDelegate()
        transitioningDelegate = delegate
        return delegate
    }()
    lazy var filterBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .white
        btn.setImage(.init(named: "shaixuanXunCha"), for: .normal)
        btn.setTitle("过滤", for: .normal)
        btn.setTitleColor(.k666666, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 8)
        btn.centerTextAndImage(imageAboveText: true, spacing: 0)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.present(wf.filterVC, animated: true)
        }
        return btn
    }()
    
    lazy var filterVC: JHFilterViewController = {
        let filter = JHFilterViewController()
        filter.handlerBlock = {[weak self] depId in
            guard let wf = self else{return}
            guard let Id = depId else {
                return
            }
            wf.departmentId = Id
            wf.loadLastFootData()
        }
        filter.transitioningDelegate = transitionDelegate
        filter.modalPresentationStyle = .custom
        return filter
    }()
    
    lazy var infoView: ReportUserInfoMapView = {
        let info = ReportUserInfoMapView()
        view.addSubview(info)
        return info
    }()
    func showInfoView(data:ReportMapUserTaskStatM) {
        infoView.isHidden = false
        infoView.snp.remakeConstraints { make in
            make.height.equalTo(92 + 74 * data.taskList.count)
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(-kEmptyBottomHeight)
        }
        infoView.dataM = data
        infoView.lasttime.text = "上传位置时间：\(currentAnnotation.reportDate)"
    }
    @objc
    func hideInfoView(tap:UITapGestureRecognizer?) {
        infoView.isHidden = true
    }
    
    @objc
    func showKeyboard(_ notf:Notification) {
        hideInfoView(tap: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UIKeyboardWillShowNotification"), object: nil)
    }
    
    //MARK: 布局器
    lazy var busTypeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "rightbusIcon"), for: .normal)
        btn.addShadow(ofColor: .init(white: 0, alpha: 0.2), radius: 3, offset: .init(width: 0, height: 1), opacity: 0.5)
        btn.addTarget(self, action: #selector(showBusinessMenu), for: .touchDown)
        return btn
    }()
    
    func showBusinessMenu() {
        
    }
    
    lazy var containsSecLayoutView: UIView = {
        let layoutView = UIView()
        layoutView.layer.backgroundColor = UIColor.white.cgColor
        layoutView.addShadow(ofColor: .init(white: 0, alpha: 0.2), radius: 3, offset: .init(width: 0, height: 1), opacity: 1)
        return layoutView
    }()
}

extension ReportUserMapController {
    
    //MARK: 获取人员数
    func loadUserPointCount(depId:String,keyword:String) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "AreaCode":"",
                                  "DepartmentId":depId,
                                  "SearchUserName":keyword]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionFootPrint/v3/GetFootPrintUserCount")
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
            let result = json["IsCompleted"].boolValue
            if result {
                if json["Data"].isEmpty {
                    return
                }
                let num = json["Data"]["UserCount"].stringValue
                weakSelf.numLab.text = "人数  \(num)      "
                weakSelf.numLab.isHidden = false
                weakSelf.perform(#selector(weakSelf.hideNumView), with: nil, afterDelay: 1.5)
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    //MARK: 获取当前人员的信息
    func requesUserInfoCard() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "ChooseUserId":currentAnnotation.userId]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/Employee/v3/GetEmployeeTaskStat")
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
            let result = json["IsCompleted"].boolValue
            if result {
                if json["Data"].isEmpty {
                    return
                }
                let rawData = try! json["Data"].rawData()
                guard let info:ReportMapUserTaskStatM = ReportMapUserTaskStatM.parsed(data: rawData) else { return }
                weakSelf.showInfoView(data: info)
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    //MARK: 获取区域部门人员列表
    func loadLastFootData() {
        loadUserPointCount(depId: departmentId, keyword: keyword)
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "DepartmentId":departmentId,
                                  "AreaCode":"",
                                  "SearchUserName":keyword]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionFootPrint/v3/GetLastFootPrint")
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
            let result = json["IsCompleted"].boolValue
            if result {
                if json["Data"].isEmpty {return}
                let rawData = try! json["Data"].rawData()
                guard let dataArray:[ReportLastFootM] = ReportLastFootM.parsed(data: rawData)else{return}
                for model in dataArray {
                    let annotation = ReportUserAnnotation()
                    annotation.userId = model.userID
                    annotation.title = model.location
                    annotation.subtitle = ""
                    annotation.reportDate = model.reportDate
                    annotation.coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
                    weakSelf.annotationArray.append(annotation)
                }
                weakSelf.mapView.addAnnotations(weakSelf.annotationArray)
//                weakSelf.mapView.selectAnnotation(weakSelf.annotationArray.first!, animated: true)
//                weakSelf.mapView.showAnnotations(weakSelf.annotationArray, animated: true)
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}


extension ReportUserMapController:MKMapViewDelegate
{
    func selectUserAnnotation(_ annotation:ReportUserAnnotation) {
        annotationArray.append(annotation)
        mapView.addAnnotations(annotationArray)
        mapView.selectAnnotation(annotation, animated: true)
    }
    // 设置“缩放级别”
    func setRegion(latitude:Double,longitude:Double) {
        // 39.95 116.36海淀中心点经纬度, 设置范围，显示地图的哪一部分以及显示的范围大小
        let center =  CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        // 调整范围
        let adjustedRegion = mapView.regionThatFits(region)
        // 地图显示范围
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
    // 用户坐标位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // 设置地图显示的中心点
        let center:CLLocationCoordinate2D = userLocation.location!.coordinate
        mapView.setCenter(center, animated: true)
        // 设置地图显示的经纬度跨度
        let span = MKCoordinateSpan(latitudeDelta: 0.023, longitudeDelta: 0.017)
        let region = MKCoordinateRegion(center: center, span: span)
        // 设置地图显示的范围
        mapView.setRegion(region, animated: true)
    }
    
    // 定制图钉样式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is ReportUserAnnotation {
            let cellid = "ReportUserAnnotationView"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: cellid)
            return annotationView
        }
        if annotation is MKUserLocation{
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserLocation")
            annotationView?.image = UIImage(named: "mapicon_blue")
            return annotationView
        }
        // nil表示使用默认样式
        return nil
    }
    // 选中
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let DesView = view as? ReportUserAnnotationView {
            DesView.image = UIImage(named: "mapuseredicon")
            if let model = DesView.annotation as? ReportUserAnnotation {
                currentAnnotation = model
                requesUserInfoCard()
            }
        }
    }
    //非选中
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let DesView = view as? ReportUserAnnotationView {
            DesView.image = UIImage(named: "mapusericon")
        }
        
    }
}
