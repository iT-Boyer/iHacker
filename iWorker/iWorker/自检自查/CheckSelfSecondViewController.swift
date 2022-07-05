//
//  CheckSelfSecondViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import SwiftyJSON
import JHBase
import MBProgressHUD

class CheckSelfSecondViewController: JHSelCheckBaseController {

    var typeId:String?
    var dataArray:[AddInsOptModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func nextStepAction() {
        super.nextStepAction()
        let third = CheckSelfThirdViewController()
        navigationController?.pushViewController(third, animated: true)
    }
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤2")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(JHSecondStepCell.self, forCellReuseIdentifier: "JHSecondStepCell")
        headerView.frame.size.height = 60
        tableView.tableHeaderView = headerView
    }
    
    lazy var headerView = JHOptionsHeaderView(name: "检查项")
    
    override func loadData() {
        super.loadData()
        if let opts = addModel.options, !opts.isEmpty {
            dataArray = opts
            return
        }
        let param:[String:Any] = ["commonParam":["appId": JHBaseInfo.appID,
                                                 "userId": JHBaseInfo.userID,
                                                 "storeId":storeId,
                                                 "selfInspectTypeId":typeId
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc/GetSelfInspectOptions")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                VCTools.toast("数据错误")
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                guard let rawData = try? json["Content"].rawData() else {return}
                guard let options:[InspectOptionModel] =  InspectOptionModel.parsed(data: rawData) else { return }
                weakSelf.dataArray = options.compactMap { origin in
                    var add = AddInsOptModel()
                    add.origin = origin
                    return add
                }
                weakSelf.addModel.options = weakSelf.dataArray
                weakSelf.addModel.toArchive()
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

extension CheckSelfSecondViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JHSecondStepCell") as! JHSecondStepCell
        cell.model = dataArray[indexPath.row]
        cell.actionHandler = {[weak self] model in
            guard let wf = self else { return }
            var currentItem:AddInsOptModel?
            wf.dataArray = wf.dataArray.compactMap{ item in
                var mm = item
                if model?.inspectOptionId == mm.inspectOptionId {
                    mm.status = model?.status
                    if let url = model?.picture {
                        if let origin = mm.picture, !origin.contains(url){
                            mm.picture = origin + ";" + url
                        }else{
                            mm.picture = url
                        }
                    }
                    currentItem = mm
                }
                return mm
            }
            guard let current = currentItem else { return }
            wf.addModel.options = wf.dataArray
            wf.addModel.toArchive()
            if let index = wf.dataArray.firstIndex(of: current){
                wf.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }else{
                wf.tableView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = InsOptDetailViewController()
        let model = dataArray[indexPath.row]
        detail.insOptId = model.inspectOptionId
        navigationController?.pushViewController(detail, completion: nil)
    }
}
