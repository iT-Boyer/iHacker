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
        [("绑定",JHBindingEditIntelDescisionVC.self),
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
        installOHHTTPStubs()
    }
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
            bind.isDetail = true
            bind.modalPresentationStyle = .fullScreen
            self.present(bind, animated: true)
            return
        }
        
        self.present(nav, animated: true, completion: nil)
    }
}
