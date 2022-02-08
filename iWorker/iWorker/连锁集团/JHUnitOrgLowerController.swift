//
//  JHUnitOrgHigherController.swift
//  iWorker
//
//  Created by boyer on 2022/2/7.
//

import UIKit

class JHUnitOrgLowerController: JHUnitOrgHigherController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = 1
        self.operateBtn.setTitle("继续添加子公司", for: .normal)
        self.tableView.register(JHUnitOrgBaseCell.self, forCellReuseIdentifier: "JHUnitOrgBaseCell")
    }
    
    override func createView() {
        super.createView()
        let titleView = UIView()
        titleView.backgroundColor = .white
        let title = UILabel()
        title.text = "我的下级"
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.textColor = .initWithHex("333333")
        titleView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(24)
            make.top.equalTo(18)
        }
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.tableView.snp.updateConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom).offset(36+16)
        }
    }
    
    override func operatection(_ btn: UIButton) {
        //跳转到搜索页，继续添加子公司
        let search = JHUnitOrgSearchController()
        search.isAddChild = true
        search.storeId = self.storeId
        search.delegate = self
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHUnitOrgBaseCell = tableView.dequeueReusableCell(withIdentifier: "JHUnitOrgBaseCell") as! JHUnitOrgBaseCell
        cell.model = self.dataArray[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { action, sourceView, completionHandler in
            if self.dataArray.count > indexPath.section {
                self.chainModel = self.dataArray[indexPath.section] as! JHUnitOrgHigherModel
                self.delfirmAcion()
            }
        }
        
        deleteAction.image = .init(named: "unitorgdelbtn")
        deleteAction.backgroundColor = .initWithHex("FC681F")
        let configuration = UISwipeActionsConfiguration.init(actions: [deleteAction])
        return configuration
    }
}
