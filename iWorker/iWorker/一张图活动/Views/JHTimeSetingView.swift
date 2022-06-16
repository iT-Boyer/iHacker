//
//  JHTimeSetingView.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit

class JHTimeSetingView: UIView {
    
    var handler:((String)->Void) = {_ in}
    init(title:String,handler:@escaping (String)->Void) {
        super.init(frame: CGRect.zero)
        createView()
        self.handler = handler
        titleLab.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var picker: JHTimePicker = {
        let time = JHTimePicker()
        time.timeHandler = {[weak self] result in
            guard let wf = self else { return }
            let format = DateFormatter()
            format.dateFormat = "YYYY年MM月dd日"
            let time = format.string(from: result)
            print("选择的时间：\(time)")
            wf.dateBtn.isSelected = true
            wf.dateBtn.setTitle(time, for: .selected)
            wf.handler(time)
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
        let arrow = UIImageView(image: .init(named: "setarrowimg"))
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
