//
//  JHTimePicker.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit

class JHTimePicker: UIViewController {

    var timeHandler:((Date)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .coverVertical
        createView()
    }
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{ super.modalPresentationStyle = newValue }
        get{ .overCurrentContext }
    }
    
    lazy var timePicker:UIDatePicker  = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.date = Date.now
        return picker
    }()
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
        cancel.setTitleColor(.k007AFF, for: .normal)
        cancel.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            wf.dismiss(animated: true)
        }
        let sure = UIButton()
        sure.setTitle("确定", for: .normal)
        sure.titleLabel?.font = .systemFont(ofSize: 17)
        sure.setTitleColor(.k007AFF, for: .normal)
        sure.jh.setHandleClick { [weak self] button in
            guard let wf = self else {return}
            wf.dismiss(animated: true) {
                wf.timeHandler(wf.timePicker.date)
            }
        }
        
        bottomView.addSubview(cancel)
        bottomView.addSubview(sure)
        bottomView.addSubview(timePicker)
        
        //layout
        cancel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.height.equalTo(20)
        }
        sure.snp.makeConstraints { make in
            make.centerY.equalTo(cancel.snp.centerY)
            make.right.equalTo(-15)
        }
        
        timePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cancel.snp.bottom).offset(10)
            make.bottom.equalTo(0)
        }
    }

}
