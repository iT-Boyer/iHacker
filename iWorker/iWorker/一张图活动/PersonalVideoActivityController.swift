//
//  PersonalVideoActivityController.swift
//  iWorker
//
//  Created by boyer on 2022/4/22.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class PersonalVideoActivityController: JHVideoActivityBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "我发布的活动"
        // Do any additional setup after loading the view.
        loadData(api: "MyActivity")
    }
    
    override func createView() {
        super.createView()
        self.tableView.register(JHPersonVideoActCell.self, forCellReuseIdentifier: "JHPersonVideoActCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHPersonVideoActCell = tableView.dequeueReusableCell(withIdentifier: "JHPersonVideoActCell") as! JHPersonVideoActCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { action, sourceView, completionHandler in
            if self.dataArray.count > indexPath.section {
                let model = self.dataArray[indexPath.row]
                self.delActivity(id: model.id, index: indexPath.row)
            }
        }
        let configuration = UISwipeActionsConfiguration.init(actions: [deleteAction])
        return configuration
    }
    
    func delActivity(id:String ,index:Int) {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_imv", path: "/api/Activity/Delete")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: ["Id":id], headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            let msg = json["Message"].stringValue
            if result {
                OperationQueue.main.addOperation {
                    weakSelf.dataArray.remove(at: index)
                    OperationQueue.main.addOperation {
                        weakSelf.tableView.reloadData()
                    }
                }
            }
//                MBProgressHUD.displayError(kInternetError)
        }
    }
}
