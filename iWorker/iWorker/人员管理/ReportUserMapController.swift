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
    
    var annotationArray:[ReportUserAnnotation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        //海淀中心点经纬度
        //float latitude = 39.95;
        //float longitude = 116.3;
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 39.95, longitude: 116.3), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        loadLastFootData()
    }
    func createView() {
        view.addSubview(mapView)
        navBar.isHidden = true
        mapView.snp.makeConstraints { make in
            make.top.bottom.left.centerX.equalToSuperview()
        }
    }
    
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.mapType = .standard
        map.userTrackingMode = .follow
        map.register(ReportUserAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ReportUserAnnotationView")
        map.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserLocation")
        return map
    }()
}

extension ReportUserMapController
{
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
                    annotation.icon = "mapusericon"
                    annotation.coordinate = CLLocationCoordinate2D(latitude: model.longitude, longitude: model.latitude)
                    weakSelf.annotationArray.append(annotation)
                }
                OperationQueue.main.addOperation {
                    weakSelf.mapView.addAnnotations(weakSelf.annotationArray)
//                    weakSelf.mapView.selectAnnotation(weakSelf.annotationArray.first!, animated: true)
                }
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
    // 更新到用户的位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //只要用户位置改变就调用此方法（包括第一次定位到用户位置），
        //userLocation：是对用来显示用户位置的蓝色大头针的封装
        // 反地理编码
        CLGeocoder().reverseGeocodeLocation(userLocation.location!) { placemarks, error in
            guard let marks = placemarks else{
                return
            }
            // 设置用户位置蓝色大头针的标题
            if let placemark = marks.first{
                userLocation.title = "当前位置：\(placemark.thoroughfare), \(placemark.locality), \(placemark.country)"
            }
            // 设置用户位置蓝色大头针的副标题
            userLocation.subtitle = "经纬度：(\(userLocation.location?.coordinate.longitude), \(userLocation.location?.coordinate.latitude))"
        }
        
        
    }
    
    // 地图显示的区域将要改变
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("""
                区域将要改变：
                经度：\(mapView.region.center.longitude)
                纬度：\(mapView.region.center.latitude)
                经度跨度：\(mapView.region.span.longitudeDelta)
                纬度跨度：\(mapView.region.span.latitudeDelta)
                """)
    }
    // 地图显示的区域改变了
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("""
                区域已经改变：
                经度：\(mapView.region.center.longitude)
                纬度：\(mapView.region.center.latitude)
                经度跨度：\(mapView.region.span.longitudeDelta)
                纬度跨度：\(mapView.region.span.latitudeDelta)
                """)
    }
    // 定制图钉样式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: ReportUserAnnotation.self) {
            // 显示自定义样式的大头针
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ReportUserAnnotationView")
            annotationView?.annotation = annotation
            return annotationView
        }
        if annotation.isKind(of: MKUserLocation.self){
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserLocation")
            annotationView?.image = UIImage(named: "mapicon_blue")
            return annotationView
        }
        return nil
    }
    // 选中
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let DesView = view as? ReportUserAnnotationView {
            DesView.image = UIImage(named: "mapuseredicon")
        }
    }
    //非选中
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let DesView = view as? ReportUserAnnotationView {
            DesView.image = UIImage(named: "mapusericon")
        }
        
    }
}
