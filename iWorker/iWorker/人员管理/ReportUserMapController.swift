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

class ReportUserMapController: JHBaseNavVC {
    
    var userModel:ReportLastFootM!
    
    var annotationArray:[ReportUserAnnotation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationMap()
        setRegion()
        createView()
        loadLastFootData()
    }
    
    func createView() {
        view.addSubviews([mapView,filterView])
        navBar.isHidden = true
        mapView.snp.makeConstraints { make in
            make.top.bottom.left.centerX.equalToSuperview()
        }
        
        filterView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
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
        return map
    }()
    
    lazy var filterView: MapFilterBarView = {
        let view = MapFilterBarView(with: "请输入人员名称") {[weak self] model in
            //TODO: 选择人员业务
            guard let wf = self else{return}
            wf.userModel = model
            let annotation = ReportUserAnnotation()
            annotation.title = model.userName
            annotation.coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
            wf.selectUserAnnotation(annotation)
        } completed: {[weak self] in
            guard let wf = self else{return}
            wf.backBtnClicked(UIButton())
        }

        return view
    }()
    
    func showInfoView(data:ReportMapUserTaskStatM) {
        let infoView = ReportUserInfoMapView()
        infoView.dataM = data
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.height.equalTo(78 + 75 * data.taskList.count)
            make.bottom.left.centerX.equalToSuperview()
        }
    }
}

extension ReportUserMapController {
    
    // 获取没人人员的信息
    func requesUserId(_ userId:String) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "ChooseUserId":userId]
        
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
                let rawData = try! json["Data"].rawData()
                let info:ReportMapUserTaskStatM = ReportMapUserTaskStatM.parsed(data: rawData)
                weakSelf.showInfoView(data: info)
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    //MARK: 获取区域部门人员
    func loadLastFootData() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "DepartmentId":JHBaseInfo.userID,
                                  "AreaCode":"",
                                  "SearchUserName":"keyword"]
        
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
                let rawData = try! json["Data"].rawData()
                let dataArray:[ReportLastFootM] = ReportLastFootM.parsed(data: rawData)
                for model in dataArray {
                    let annotation = ReportUserAnnotation()
                    annotation.userId = model.userID
                    annotation.title = model.location
                    annotation.subtitle = ""
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
    func setRegion() {
        //海淀中心点经纬度, 设置范围，显示地图的哪一部分以及显示的范围大小
        let center =  CLLocationCoordinate2D(latitude: 39.95, longitude: 116.36)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        // 调整范围
        let adjustedRegion = mapView.regionThatFits(region)
        // 地图显示范围
        mapView.setRegion(adjustedRegion, animated: true)
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
                requesUserId(model.userId)
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
