//
//  JHSelCheckBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase

class JHSelCheckBaseController: JHBaseNavVC {

    var storeId = "00000000-0000-0000-0000-000000000000"
    var profiles:[String] = []
    var addModel: AddSelfInsModel = {
        if let model = AddSelfInsModel.unArchive(){
            return model
        }
        // 初始化
        var newModel = AddSelfInsModel()
        newModel.record = AddRecordModel()
        newModel.options = []
        newModel.profiles = []
        newModel.record?.appId = JHBaseInfo.appID
        newModel.record?.userId = JHBaseInfo.userID
        return newModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        JHLocationManager.shared.startLocation {[weak self] location in
            guard let wf = self else{return}
            wf.refreshLocationUI(location: location)
        }
        addModel.record?.storeId = storeId
        addModel.record?.inspectDate = today
        createView()
        loadData()
    }
    
    func loadData() {}
    
    @objc
    func nextStepAction() {
        //TODO: 下一步
        print("下一步....")
    }
    
    func createView() {
        navTitle = "自检自查"
        navBar.backgroundColor = .clear
        navBar.titleLabel.textColor = .white
        navBar.lineView.isHidden = true
        navBar.backBtn.setImage(.init(named: "Inspect返回"), for: .normal)
        
        view.addSubviews([fiveFirstView, fiveSecondView, waterView, stepView, tableView])
        view.sendSubviewToBack(waterView)
        let index = view.subviews.firstIndex(of: navBar) ?? 0
        view.insertSubview(stepView, at: index)
        
        fiveFirstView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.size.equalTo(CGSize(width: 187, height: 112))
            make.right.equalToSuperview()
        }
        fiveSecondView.snp.makeConstraints { make in
            make.size.equalTo(fiveFirstView)
            make.right.bottom.equalToSuperview()
        }
        waterView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(20)
            make.right.left.bottom.equalToSuperview()
        }
        stepView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            let height = kPhoneXSeries ? 150:130
            make.height.equalTo(height)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
        
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        footerView.frame.size.height = height
        tableView.tableFooterView = footerView
    }
    
    func refreshLocationUI(location:JHLocation) {
        addModel.record?.location = location.desc
        addModel.record?.longitude = location.longitude
        addModel.record?.latitude = location.latitude
        addModel.toArchive()
        let mark = JHBaseInfo.userAccount + "  " + today + "  " + location.desc
        waterView.addWaterText(text: mark, color: waterColor, font: .systemFont(ofSize: 15))
    }
    
    func setStepImage(img:String) {
        let image = UIImage(named: img)
        //resizableImageWithCapInsets: 指定拉伸区域
        let rect = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        stepView.image = image?.resizableImage(withCapInsets: rect, resizingMode: .stretch) //拉伸
    }
    
    func fiveWaterMarkAction() {
        //TODO: 开启五定拍照
        profiles = ["url"]
    }
    
    lazy var waterView: UIView = {
        let water = UIView()
        let mark = JHBaseInfo.userAccount + "  " + today + today + today
        water.addWaterText(text: mark, color: waterColor, font: .systemFont(ofSize: 15))
        return water
    }()
    
    lazy var waterColor = UIColor(white: 0, alpha: 0.2)
    
    lazy var fiveFirstView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var fiveSecondView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var today: String = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = NSDate() as Date
        let time = format.string(from: now)
        return time
    }()
    
    // 导航条背景图
    lazy var stepView: UIImageView = {
        let header = UIImageView()
        header.contentMode = .scaleToFill
        return header
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        tb.removeTableFooterView()
        tb.separatorStyle = .singleLine
        tb.estimatedRowHeight = 75
        tb.separatorColor = .initWithHex("A9A9A9")
        tb.separatorInset = .init(top: 0.5, left: 0, bottom: 0, right: 0)
        tb.rowHeight = UITableView.automaticDimension
        if #available (iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.5
        }
        return tb
    }()
    
    lazy var footerView: UIView = {
        let footer = UIView()
        footer.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.height.equalTo(50)
            make.top.equalTo(40)
            make.center.equalToSuperview()
        }
        return footer
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("下一步", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .initWithHex("FDAD44")
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(nextStepAction), for: .touchDown)
        return btn
    }()
}

extension JHSelCheckBaseController:UITableViewDelegate
{
    /// 禁止悬浮
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let sectionHeaderHeight = 60.0
            if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= sectionHeaderHeight
            {
                scrollView.contentInset = .init(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            }else
            if (scrollView.contentOffset.y >= sectionHeaderHeight){
                scrollView.contentInset = .init(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
            }
        }
    }
}

