//
//  ViewController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import UIKit
import SnapKit
import JHBase

class ViewController: JHBaseNavVC {

    var page:UIViewController!
    var rows:[(String, UIViewController.Type)]{
        [("自检自查", CheckSelfViewController.self),
         ("|--检查结果", CheckDetailViewController.self),
         ("图片集首页", PhotoHomeController.self),
         ("|- 品牌宣传",JHPhotoDetailController.self),
         ("|- 图片集列表",JHPictureGroupController.self),
         ("人员管理地图",ReportUserMapController.self),
         ("消息设置",JHNotificationCenterManagerViewController.self),
         ("账号安全",AccountSecurityViewController.self),
         ("活动广场",VideoActivitySquareController.self),
         ("|- 我发布的活动",PersonalVideoActivityController.self),
         ("|- 发布活动",JHCreateVideoActController.self),
         ("|- 活动详情",JHVideoActDetailController.self),
         ("绑定",JHBindingEditIntelDescisionVC.self),
         ("| 自动绑定",JHBindingEditIntelDescisionVC.self),
         ("| 详情编辑",JHBindingEditIntelDescisionVC.self),
         ("设置",JHPriDeviceSetingController.self),
         ("分享预览",JHShareDevicePreController.self),
         ("接受邀请",JHDeviceInvitedController.self),
         ("晨检机",JHMornInspecterController.self),
         ("| 连锁集团",JHUnitJoinOrgViewController.self),
         ("|- 上级",JHUnitOrgHigherController.self),
         ("|- 下级",JHUnitOrgLowerController.self)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navTitle = "金和"
        self.navBar.backBtn.isHidden = true
        self.view.backgroundColor = UIColor.white
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "modeCell")
        self.view.addSubview(tableview)
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        headerView.frame.size.height = 400
        tableview.tableHeaderView = headerView
        view.layoutIfNeeded()
//        firstlab.frame = CGRect(x: 0, y: 0, width: 40, height: 200)
        installOHHTTPStubs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        firstlab.frame = CGRect(x: 0, y: 0, width: 40, height: 200)
//        firstlab.center = headerView.center
    }
    lazy var headerView: UIView = {
        let header = UIView()
        
        header.addSubview(firstlab)
        header.addSubview(secondBtn)
        return header
    }()
    
    
    lazy var firstlab: UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: 80, y: 90, width: 200, height: 40)
        lab.text = "旋转"
        lab.font = .systemFont(ofSize: 24)
        lab.textColor = .red
        lab.textAlignment = .center
        
        lab.transform = .init(rotationAngle: Double.pi / 2)
        lab.layer.borderColor = UIColor.red.cgColor
        lab.layer.borderWidth = 1
        
//        lab.layer.transform = .init(rotationAngle: Double.pi / 2, x: 0, y: 0, z: 0)
        return lab
    }()
    
    lazy var secondBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 160, y: 80, width: 200, height: 40))
        btn.setTitle("旋转按钮", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setBackgroundImage(UIImage(color: .gray, size: CGSize(width: 1, height: 1)), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.transform = .init(rotationAngle: .pi/2)
        return btn
    }()
}

extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modeCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let key = rows[indexPath.row].0
        cell.textLabel?.text = key
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cls: AnyClass = rows[indexPath.row].1
//        let vc:UIViewController = class_createInstance(cls,0) as! UIViewController
        let cls:UIViewController.Type  = rows[indexPath.row].1
        let desc = rows[indexPath.row].0
        let vc = cls.init()
        page = vc
        let nav = UINavigationController(rootViewController: vc)
        
        if vc.modalPresentationStyle == .overCurrentContext {
            // 模拟首页扫一扫，邀请好友弹出框样式
            nav.modalPresentationStyle = .overCurrentContext
            if cls.isEqual(JHDeviceInvitedController.self) {
                let code = "https://testripx.iuoooo.com/swagger/index.html?invitecode=7zKJyisuzdvKCeFgeTtDJUfTk8lgHQPQCK47ZV6z5E38lzDmohHUreCHkrzzYpZpvu0mbTv9ZmCx48njD1RmFHXgyZKkfxKYtystJQK9t4PzS/WZ3HmNuuX74CSHAKaXUrTUjThI+LFwwl1etlUgCkC12BMc6fKby/+1bCSBAz9gFL7UA7YLr3p9e7/yUdQmZKxQK+kCyANzZ9xcjd7lq7dHsoDP/zyodSu/ONWh3eX/g9QCk4A0gOZSUEcrk4yb8+9xG/CfkBzOUp9w9SiaJxIUPQkQ448SO2NJSWObghAemzT12Cnykw=="
                JHDeviceInviteAPI.inviteInfo(code)
                return
            }
        }else{
            nav.modalPresentationStyle = .fullScreen
        }
        
        //模拟自动绑定设备逻辑
        if cls.isEqual(JHBindingEditIntelDescisionVC.self) && desc == "| 自动绑定" {
            let sn = "jkjk908jkhk09"
            Tools.showClsRuntime(cls: JHBindingEditIntelDescisionVC.self)
            let bind = JHBindingEditIntelDescisionVC()
            page = bind
            bind.scanBind(sn, type: .scanIndex)
            return
            // 实例方法
            let method = Selector("scanBind:")
            if vc.responds(to: method){
                // vc.perform(codemethod)
                vc.perform(method, with: sn)
            }
            return
        }
        
        if desc.hasSuffix("详情编辑") {
            let bind = JHBindingEditIntelDescisionVC()
            bind.pageType = .detail
            bind.modalPresentationStyle = .fullScreen
            self.present(bind, animated: true)
            return
        }
        
        self.present(nav, animated: true, completion: nil)
    }
}
