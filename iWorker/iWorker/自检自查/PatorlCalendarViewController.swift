//
//  PatorlCalendarViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import FSCalendar
import SwiftyJSON
import MBProgressHUD

class PatorlCalendarViewController: JHBaseNavVC {

    var storeId = ""
    var record:InsOneMonthModel?
    var dataArray:[InspectDayModel]{ record?.comInspectDayList ?? [] }
    var collectionArray:[InsYearModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "自检自查日历表"
        navBar.titleLabel.textColor = .white
        navBar.lineView.isHidden = true
        navBar.backgroundColor = .clear
        navBar.backBtn.setImage(.init(named: "Inspect返回"), for: .normal)
        // Do any additional setup after loading the view.
        createView()
        loadData()
        loadYearData()
    }
    
    func createView() {
        
        navBar.addSubview(inspectBtn)
        inspectBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 50))
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-10)
        }
        
        let backView = UIImageView(image: .init(named: "Inspect日历背景"))
        view.addSubviews([backView, bodyView])
        view.sendSubviewToBack(backView)
        backView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-kEmptyBottomHeight-10)
        }
    }
    
    lazy var bodyView: UIView = {
        let body = UIView()
        body.backgroundColor = .init(white: 1, alpha: 0.1)
        body.layer.cornerRadius = 5
        body.addSubviews([calendar, collectionView])
        calendar.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(40)
            make.leading.equalTo(calendar.snp.leading)
            make.trailing.equalTo(calendar.snp.trailing)
            make.height.equalTo(100)
            make.bottom.equalTo(-30)
        }
        return body
    }()
    
    
    lazy var calendar: FSCalendar = {
        let fs = FSCalendar()
        fs.dataSource = self
        fs.delegate = self
        fs.appearance.caseOptions = .weekdayUsesSingleUpperCase
        fs.appearance.headerTitleColor = .white
        fs.appearance.headerDateFormat = "yyyy/MM"
        fs.appearance.weekdayTextColor = .white
        fs.appearance.titleDefaultColor = .white
        fs.appearance.selectionColor = .clear
        fs.appearance.imageOffset = .init(x: 0, y: -20) //自定义图片偏移量
        fs.register(InspectCalendarCell.self, forCellReuseIdentifier: "InspectCalendarCell")
        return fs
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 74, height: 99)
        layout.sectionInset = .zero
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(CalendarBottomCell.self, forCellWithReuseIdentifier: "CalendarBottomCell")
        return collection
    }()
    
    lazy var inspectBtn: UIButton = {
        let inspect = UIButton()
        inspect.setImage(.init(named: "Inspect添加"), for: .normal)
        inspect.imageEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 0)
        inspect.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 新增自查
            let inspect = CheckSelfViewController()
            inspect.storeId = wf.storeId
            wf.navigationController?.pushViewController(inspect)
        }
        return inspect
    }()
    
    func bindStoreId(notif:Notification) {
        guard let data = notif.userInfo else { return }
        let userinfo = JSON(data)
        let storeid = userinfo["storeId"].stringValue
        let fromStoreDetail = userinfo["fromStoreDetail"].boolValue
        inspectBtn.isHidden = fromStoreDetail
        if storeid.count > 6 {
            
        }else{
            backBtnClicked(UIButton())
        }
    }
}

extension PatorlCalendarViewController:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarBottomCell", for: indexPath) as! CalendarBottomCell
        cell.model = collectionArray[indexPath.row]
        return cell
    }
}

extension PatorlCalendarViewController:FSCalendarDelegate, FSCalendarDataSource
{
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateStr = date.string(withFormat: "yyyy/M/d")
        if let _ = dataArray.filter({$0.inspectDate == dateStr}).first{
            return UIImage(named: "Inspect已查")
        }
        return nil
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        loadData()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        //TODO: 自定义样式
        let cell = calendar.dequeueReusableCell(withIdentifier: "InspectCalendarCell", for: date, at: position) as! InspectCalendarCell
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let day = date.string(withFormat: "yyyy/M/d")
        let arr = record?.comInspectRecordList?.filter{ item in
            guard let orgStr = item.inspectDate else{ return false }
            let lastindex = orgStr.count - 9
            let daystr = orgStr[..<lastindex]
            return daystr == day
        }
        guard let records = arr, !records.isEmpty else { return }
        if records.count == 1{
            guard let first = records.first else { return }
            let detail = CheckDetailViewController()
            detail.reportId = first.id ?? ""
            navigationController?.pushViewController(detail)
        }else{
            var actions = records.compactMap{ item -> String? in
                let types = records.filter{$0.selfInspectTypeID == item.selfInspectTypeID}
                if types.count == 1 {
                    return item.selfInspectType
                }else{
                    if let dateStr = item.inspectDate {
                        let time = dateStr.dateTime
                        let timestr = time?.string(withFormat: "HH:mm")
                        return (item.selfInspectType ?? "") + " " + (timestr ?? "")
                    }
                    return item.selfInspectType
                }
            }
            if actions.isEmpty { return }
            var styles = actions.compactMap{_ -> UIAlertAction.Style in .default}
            actions.append("取消")
            styles.append(.cancel)
            UIAlertController.showDarkSheet(style: .actionSheet, btns: actions, types: styles) {[weak self] row in
                if row == actions.count - 1 { return }
                guard let wf = self else { return }
                let item = records[row]
                let detail = CheckDetailViewController()
                detail.reportId = item.id ?? ""
                wf.navigationController?.pushViewController(detail)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { make in
//            make.height.equalTo(400)
//        }
//        view.layoutIfNeeded()
//    }

    func loadData() {
        let month = calendar.currentPage.string(withFormat: "yyyy-MM")
        let param:[String:Any] = ["commonParam":["appId":JHBaseInfo.appID,
                                                 "startTime": month,
                                                 "storeId":storeId
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectRecordSV.svc/GetComSelfInspection1")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                VCTools.toast("数据错误")
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                guard let rawData = try? json["Content"].rawData() else {return}
                guard let info:InsOneMonthModel =  InsOneMonthModel.parsed(data: rawData) else { return }
                weakSelf.record = info
                weakSelf.calendar.reloadData()
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
    
    func loadYearData() {
        let year = calendar.currentPage.string(withFormat: "yyyy")
        let param:[String:Any] = ["commonParam":["appId":JHBaseInfo.appID,
                                                 "year": year,
                                                 "storeId":storeId
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectRecordSV.svc/GetYearComSelfInspection")
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                VCTools.toast("数据错误")
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                guard let rawData = try? json["Content"].rawData() else {return}
                guard let info:[InsYearModel] =  InsYearModel.parsed(data: rawData) else { return }
                weakSelf.collectionArray = info
                weakSelf.collectionView.reloadData()
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

