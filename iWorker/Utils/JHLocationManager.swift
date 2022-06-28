//
//  JHLocationManager.swift
//  iWorker
//
//  Created by boyer on 2022/6/2.
//

import UIKit
import CoreLocation

struct JHLocation {
    var latitude,longitude:Double
    var city,subLocality,address:String
    var desc: String {
        "\(city)-\(subLocality)-\(address)"
    }
}

class JHLocationManager: NSObject{

    // 单例初始化
    static let shared = JHLocationManager()
    var manager:CLLocationManager!
    var currLocation:JHLocation?
    var complatedHandler:(JHLocation)->Void = {_ in}
    override init() {
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        //定位精度10m
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //移动100m之后，重新定位
        manager.distanceFilter = 100
    }
    
    //MARK: API
    func startLocation(complated:@escaping (JHLocation)->Void) {
        complatedHandler = complated
        requestLocationServicesEnabled()
    }
    
    // 开启定位
    func triggerLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            // 第一次启动请求权限
            if manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))
                || manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil {
                    manager.requestAlwaysAuthorization()
                }else if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil{
                    manager.requestWhenInUseAuthorization()
                }else{
                    print("Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription")
                }
            }
            
        }else{
            // 定位服务未开启
            requestLocationServicesEnabled()
        }
    }
    
    func requestLocationServicesEnabled() {
        switch manager.authorizationStatus {
        case .authorized,.authorizedWhenInUse,.authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        case .denied,.restricted:
            let alert = UIAlertController(title: "温馨提示", message: "如果需要定位服务请在设置中打开定位", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            let ok = UIAlertAction(title: "打开定位", style: .default) { action in
                if let url = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            UIViewController.topVC?.present(alert, animated: true)
            break
        default:
            print("")
        }
    }
}

extension JHLocationManager:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else{ return }
        reverseGeocde(last)
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
    
    // 由坐标点获取地理信息
    func reverseGeocde(_ location:CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] placemarks, error in
            guard let wf = self else{return}
            if let placemark = placemarks?.first{
                wf.geoLocation(placemark)
            }
        }
    }
    
    // 由地理名称 获取 地理信息
    func geocodeQuery(name:String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { [weak self] placemarks, error in
            guard let wf = self else{return}
            if let placemark = placemarks?.first{
                wf.geoLocation(placemark)
            }
        }
    }
    
    // 封装地理信息对象
    func geoLocation(_ placemark:CLPlacemark) {
        //城市
        var city:String = placemark.locality ?? ""
        if city == "" {
            //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
            city = placemark.administrativeArea  ?? ""
        }
        
        currLocation = JHLocation(latitude: placemark.location?.coordinate.latitude ?? 0.0,
                                  longitude: placemark.location?.coordinate.longitude ?? 0.0,
                                  city: city,
                                  subLocality: placemark.subLocality ?? "",
                                  address: placemark.name ?? "")
        guard let location = currLocation else { return }
        complatedHandler(location)
    }
}
