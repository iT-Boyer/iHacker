//
//  JHAddActivityBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit
import JHBase
import Kingfisher
import SwiftyJSON
import MBProgressHUD

class JHAddActivityBaseController: JHBaseNavVC {

    var startTime = ""
    var endTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
    }

    func upload() {}
    
    func createView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        
        let line = UIView()
        line.backgroundColor = .initWithHex("EEEEEE")
        let line2 = UIView()
        line2.backgroundColor = .initWithHex("F6F6F6")
        scrollView.addSubviews([photo,startDate,line,endDate,line2,field,textView])
        
        photo.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        
        startDate.snp.makeConstraints { make in
            make.top.equalTo(photo.snp.bottom)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(startDate.snp.bottom)
            make.height.equalTo(0.5)
            make.left.centerX.equalToSuperview()
        }
        
        endDate.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        line2.snp.makeConstraints { make in
            make.top.equalTo(endDate.snp.bottom)
            make.height.equalTo(10)
            make.left.centerX.equalToSuperview()
        }
        field.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(10)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        let height = view.frame.size.height - 320 - navBar.frame.size.height
        textView.snp.makeConstraints { make in
            make.top.equalTo(field.snp.bottom).offset(10)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(height)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    
    //MARK: - 懒加载
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var photo: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "JHShortVideoResource.bundle/uploadImg"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.imageView?.clipsToBounds = true
        btn.jh.setHandleClick { [self] button in
            self.upload()
        }
        return btn
    }()
    lazy var textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textColor = .initWithHex("99A0B6")
        view.returnKeyType = .done
        view.text = "活动内容介绍"
        view.backgroundColor = .initWithHex("F7F7F7")
        view.font = .systemFont(ofSize: 14)
        view.textContainerInset = .init(top: 15, left: 12, bottom: 5, right: 12)
        return view
    }()
    lazy var field: UITextField = {
        let view = UITextField()
        view.textColor = .initWithHex("2F3856")
        view.font = .systemFont(ofSize: 15)
        view.returnKeyType = .done
        view.attributedPlaceholder = NSAttributedString(string: "添加标题", attributes: [NSAttributedString.Key.foregroundColor:UIColor.initWithHex("99A0B6")])
        return view
    }()
    
    lazy var startDate: JHTimeSetingView = {
        let time = JHTimeSetingView(title: "活动开始时间") { tim in
            self.startTime = tim
        }
        return time
    }()
    
    lazy var endDate: JHTimeSetingView = {
        let time = JHTimeSetingView(title: "活动结束时间") { tim in
            self.endTime = tim
        }
        return time
    }()
}
