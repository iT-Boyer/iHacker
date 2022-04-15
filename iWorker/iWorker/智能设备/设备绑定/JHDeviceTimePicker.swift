//
//  JHDeviceTimePicker.swift
//  iWorker
//
//  Created by boyer on 2022/3/24.
//

import UIKit
import JHBase

class JHDeviceTimePicker: UIViewController {

    var timeHandler:(String,String)->() = {_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .coverVertical
        createView()
    }
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{ super.modalPresentationStyle = newValue }
        get{ .overCurrentContext }
    }
    func createView() {
        view.backgroundColor = .init(white: 0, alpha: 0.6)
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(260)
        }
        // 取消确定按钮
        let cancel = UIButton()
        cancel.setTitle("取消", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 17)
        cancel.setTitleColor(.initWithHex("007AFF"), for: .normal)
        cancel.jh.setHandleClick { button in
            self.dismiss(animated: true)
        }
        let sure = UIButton()
        sure.setTitle("确定", for: .normal)
        sure.titleLabel?.font = .systemFont(ofSize: 17)
        sure.setTitleColor(.initWithHex("007AFF"), for: .normal)
        sure.jh.setHandleClick { [self] button in
            //TODO: 添加时间戳
            let format = DateFormatter()
            format.dateFormat = "HH:mm" //24小时制， @"hh:mm" 12小时制
            let startTime = format.string(from: startPicker.date)
            let endTime = format.string(from: self.endPicker.date)
            //比较
            let result = startPicker.date.compare(self.endPicker.date)
            if (result == .orderedDescending || startTime == endTime) {
                VCTools.toast("开始时间不能大于结束时间开始时间不能大于结束时间开始时间不能大于结束时间开始时间不能大于结束时间开始时间不能大于结束时间")
                return
            }
            self.dismiss(animated: true) {
                self.timeHandler(startTime,endTime)
            }
        }
        
        let lab = UILabel()
        lab.text = "到"
        lab.textAlignment = .center
        lab.textColor = .initWithHex("007AFF")
        lab.font = .systemFont(ofSize: 17)
        
        bottomView.addSubview(cancel)
        bottomView.addSubview(sure)
        bottomView.addSubview(lab)
        bottomView.addSubview(startPicker)
        bottomView.addSubview(endPicker)
        
        //layout
        cancel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.height.equalTo(20)
        }
        sure.snp.makeConstraints { make in
            make.centerY.equalTo(cancel.snp.centerY)
            make.right.equalTo(-15)
        }
        
        startPicker.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(cancel.snp.bottom).offset(10)
            make.bottom.equalTo(0)
        }
        lab.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.left.equalTo(startPicker.snp.right)
            make.centerY.equalTo(startPicker.snp.centerY)
        }
        endPicker.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(lab.snp.right)
            make.centerY.equalTo(startPicker.snp.centerY)
            make.bottom.equalToSuperview()
        }
    }
    
    lazy var startPicker:UIDatePicker  = {
        let picker = createPicker()
        return picker
    }()
    
    lazy var endPicker:UIDatePicker = {
        let picker = createPicker()
        return picker
    }()
    
    func createPicker()->UIDatePicker {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.date = Date.now
        //设置为24小时制
        picker.locale = Locale(identifier: "en_GB")
        return picker
    }
}
