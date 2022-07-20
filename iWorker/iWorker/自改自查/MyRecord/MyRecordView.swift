//
//  MyRecordView.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import UIKit
import JHBase
import Viperit
import FSCalendar

//MARK: MyRecordView Class
final class MyRecordView: ReformBaseNavVC, FSCalendarDelegate,FSCalendarDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "我的自查记录"
        
    }
    
    override func createView() {
        super.createView()
        
    }
    
    lazy var calendar: FSCalendar = {
        let fs = FSCalendar()
        fs.dataSource = self
        fs.delegate = self
        fs.appearance.caseOptions = .weekdayUsesSingleUpperCase
        fs.appearance.separators = .none
        fs.appearance.headerTitleColor = .k2F3856
        fs.appearance.headerDateFormat = "yyyy/MM"
        fs.appearance.weekdayTextColor = .k333333
        fs.appearance.titleDefaultColor = .k333333
        fs.appearance.selectionColor = .initWithHex("FF2600", alpha: 0.44)
        fs.appearance.todayColor = .initWithHex("FF2600", alpha: 0.44)
        fs.appearance.titleTodayColor = .white
        fs.appearance.titleSelectionColor = .white
        fs.allowsSelection = true
        fs.firstWeekday = 2
        fs.appearance.imageOffset = .init(x: 0, y: -20) //自定义图片偏移量
        fs.register(InspectCalendarCell.self, forCellReuseIdentifier: "InspectCalendarCell")
        return fs
    }()
    
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
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { make in
//            make.height.equalTo(400)
//        }
//        view.layoutIfNeeded()
//    }
    
}

//MARK: - MyRecordView API
extension MyRecordView: MyRecordViewApi {
}

// MARK: - MyRecordView Viper Components API
private extension MyRecordView {
    var presenter: MyRecordPresenterApi {
        return _presenter as! MyRecordPresenterApi
    }
    var displayData: MyRecordDisplayData {
        return _displayData as! MyRecordDisplayData
    }
}

