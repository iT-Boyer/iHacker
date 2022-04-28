//
//  JHTimeSetingView.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit

class JHTimeSetingView: UIView {
    
    init(title:String,handler:(String)->Void) {
        super.init(frame: CGRect.zero)
        createView()
        titleLab.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var picker: JHTimePicker = {
        let time = JHTimePicker()
        time.timeHandler = {[unowned self] result in
            let format = DateFormatter()
            format.dateFormat = "YYYY年MM月dd日"
            let time = format.string(from: result)
            print("选择的时间：\(time)")
            dateBtn.isSelected = true
            dateBtn.setTitle(time, for: .selected)
        }
        return time
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .initWithHex("2F3856")
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    
    lazy var dateBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("请选择时间", for: .normal)
        btn.setTitleColor(.initWithHex("99A0B6"), for: .normal)
        btn.setTitleColor(.initWithHex("2F3856"), for: .selected)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.jh.setHandleClick {[unowned  self] button in
            superview?.endEditing(true)
            UIViewController.topVC?.present(picker, animated: true, completion: nil)
        }
        return btn
    }()
    
    
    func createView() {
        let arrow = UIImageView(image: .init(named: "JHShortVideoResource.bundle/setarrowimg"))
        addSubviews([titleLab,dateBtn,arrow])
        titleLab.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerY.left.equalToSuperview()
            make.width.equalTo(180)
        }
        
        dateBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right)
            make.centerY.equalToSuperview()
        }
        
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 7, height: 13))
            make.left.equalTo(dateBtn.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
    }
}
