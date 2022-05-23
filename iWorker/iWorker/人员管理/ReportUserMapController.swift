//
//  ReportUserMapController.swift
//  iWorker
//
//  Created by boyer on 2022/5/23.
//

import JHBase
import MapKit

class ReportUserMapController: JHBaseNavVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        //海淀中心点经纬度
        //float latitude = 39.95;
        //float longitude = 116.3;
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 39.95, longitude: 116.3), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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
        map.mapType = .standard
        map.userTrackingMode = .follow
        return map
    }()
}
