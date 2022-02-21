//
//  JHPriDeviceSetingController.swift
//  iWorker
//
//  Created by boyer on 2022/2/21.
//

import UIKit
import JHBase

@objc(JHPriDeviceSetingController)
class JHPriDeviceSetingController: JHBaseNavVC,UITableViewDelegate,UITableViewDataSource {
    
    let rows = ["邀请好友", "邀请管理", "编辑设备"]
    let rowsimg = ["setinviteimg", "setmanageimg", "seteditimg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "设置"
        self.view.backgroundColor = UIColor.white
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorColor = .red//.initWithHex("EEEEEE")
        tableview.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "modeCell")
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modeCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let key = rows[indexPath.row]
        cell.textLabel?.text = key
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .initWithHex("2F3856")
        cell.imageView?.image = .init(named: rowsimg[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
