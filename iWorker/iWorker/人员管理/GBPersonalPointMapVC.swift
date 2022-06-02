//
//  GBPersonalPointMapVC.swift
//  iWorker
//
//  Created by boyer on 2022/6/2.
//

import UIKit
import JHBase
import MapKit
import SwiftyJSON
import MBProgressHUD

class GBPersonalPointMapVC: JHBaseNavVC {

    var userId = ""
    var dateStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "足迹"
        createView()
        if dateStr == "" {
            dateStr = today
        }
        loadData(by: dateStr)
    }
    
    func createView() {
        //导航条右边按钮
        let listBtn = UIButton()
        //GBCityTreatResource.bundle/toList
        listBtn.setImage(.init(named: "toList"), for: .normal)
        listBtn.jh.setHandleClick { [weak self] button in
            guard let wf = self else{return}
            let track = ReportTrackPachController()
            track.userId = wf.userId
            wf.navigationController?.pushViewController(track)
        }
        let dateBtn = UIButton()
        dateBtn.setImage(.init(named: "chooseTime"), for: .normal)
        dateBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.navigationController?.present(wf.picker, animated: true)
        }
        
        navBar.addSubviews([listBtn,dateBtn])
        listBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        dateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-8)
            make.left.equalTo(listBtn.snp.right)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
    }
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.mapType = .standard
        map.showsUserLocation = false
        map.register(JHBMKAnnotationListView.self, forAnnotationViewWithReuseIdentifier: "JHBMKAnnotationListView")
        return map
    }()
    lazy var picker: JHTimePicker = {
        let time = JHTimePicker()
        time.timeHandler = {[weak self] result in
            guard let wf = self else {return}
            let format = DateFormatter()
            format.dateFormat = "YYYY-MM-dd"
            let date = format.string(from: result)
            wf.loadData(by: date)
        }
        return time
    }()
    var today: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let now = NSDate() as Date
        let time = format.string(from: now)
        return time
    }
    func loadData(by date:String) {
        let param:[String:Any] = ["UserId":userId,
                                  "AppId":JHBaseInfo.appID,
                                  "ReportDate":date,
                                  ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionFootPrint/v3/GetDayFootPrint")
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
                    //暂无足迹记录
                    return
                }
                let rawData = try! json["Data"].rawData()
                guard let trackPach:ReportTrackPachM =  ReportTrackPachM.parsed(data: rawData) else { return }
                weakSelf.refreshTrackPath(locations: trackPach.locationList)
            }
        }
    }
}

extension GBPersonalPointMapVC:MKMapViewDelegate
{
    //更新路径
    func refreshTrackPath(locations:[ReportLocationM]) {
        guard let first = locations.first else{
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
        mapView.setCenter(coordinate, animated: true)
        // 0.003 0.003
        let region = MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003))
        let adjusted = mapView.regionThatFits(region)
        mapView.setRegion(adjusted, animated: true)
        
        let annoArr = locations.compactMap { model -> JHPersonalAnnocation in
            //添加足迹点
            let anno = JHPersonalAnnocation()
            anno.title = model.location
            anno.subtitle = model.reportTime
            anno.coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
            anno.imageName = "personalLocation"
            return anno
        }
        mapView.addAnnotations(annoArr)
        
        let coords = annoArr.compactMap { model -> CLLocationCoordinate2D in
            model.coordinate
        }
        //执行画线方法
        let cc = MKPolyline(coordinates: coords, count: locations.count)
        mapView.addOverlay(cc)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline =  overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = .k428BFE
            renderer.fillColor = .k428BFE
            renderer.lineWidth = 4
            renderer.lineDashPhase = 8
            renderer.lineDashPattern = [5,5]
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView:JHBMKAnnotationListView = mapView.dequeueReusableAnnotationView(withIdentifier: "JHBMKAnnotationListView") as! JHBMKAnnotationListView
        if let anno = annotation as? JHPersonalAnnocation {
            annotationView.model = anno
        }
        return annotationView
    }
}
