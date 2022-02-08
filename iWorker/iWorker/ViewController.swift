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

    var rows:[(String, UIViewController.Type)]{
        [("晨检机",JHMornInspecterController.self),
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
        let vc = cls.init()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
