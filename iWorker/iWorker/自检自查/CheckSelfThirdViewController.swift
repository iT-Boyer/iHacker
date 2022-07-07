//
//  CheckSelfThirdViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class CheckSelfThirdViewController: JHSelCheckBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤3")
        
        bottomBtn.setTitle("保存生成报告", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JHInspectInfoCell.self, forCellReuseIdentifier: "JHInspectInfoCell")
        tableView.register(JHThirdStepCell.self, forCellReuseIdentifier: "JHThirdStepCell")
        tableView.register(CheckNoteCell.self, forCellReuseIdentifier: "CheckNoteCell")
        tableView.register(CheckSignCell.self, forCellReuseIdentifier: "CheckSignCell")
    }
    
    override func nextStepAction() {
        super.nextStepAction()
        
        guard let remark = addModel.record?.remark ,!remark.isEmpty else{
            VCTools.toast("请完成备注信息")
            return
        }
        guard let sigin = addModel.record?.inspectSignature ,!sigin.isEmpty else{
            VCTools.toast("请完成签名")
            return
        }
        
        let param:[String:Any] = addModel.toParams()
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc/AddSelfInspect")
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
                AddSelfInsModel.clearArchive()
                InspectInfoModel.clearArchive()
                let recordId = json["Data"].stringValue
                let report = CheckReportViewController()
                report.reportId = recordId
                weakSelf.navigationController?.pushViewController(report, animated: true)
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
    
    lazy var dataArray:[[Any]] = [infoArray,optionsArray, signArray] as [[Any]]
    
    lazy var infoModel = InspectInfoModel.unArchive()
    
    lazy var infoArray: [CheckerBaseVM] = {
        guard let info = infoModel else{ return []}
        var type = ""
        if let itype = addModel.record?.selfInspectType{
            type = itype
        }
        let data = [CheckerBaseVM(icon: "Inspect经营者名称",
                                  name: "经营者名称",
                                  value: info.storeName),
                    CheckerBaseVM(icon: "Inspect自查类型",
                                  name: "自查类型",
                                  value: type),
                    CheckerBaseVM(icon: "Inspect检查次数",
                                  name: "检查时间",
                                  value: today),
                    CheckerBaseVM(icon: "Inspect业态类型",
                                  name: "业态类型",
                                  value: info.storeTypeName)
        ]
        return data
    }()
    
    lazy var optionsArray: [AddInsOptModel] = {
        if let opts = addModel.options, !opts.isEmpty{
            return opts
        }
        return []
    }()

    lazy var signArray: [CheckEditCellVM] = {
        let note = addModel.record?.remark ?? ""
        let sign = addModel.record?.inspectSignature ?? ""
        let notevm = CheckEditCellVM(type: .note, note: note)
        let signvm = CheckEditCellVM(type: .sign, picture: sign)
        return [notevm, signvm]
    }()
    
    lazy var headerView = JHOptionsHeaderView(name: "检查项")
}

extension CheckSelfThirdViewController:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHInspectInfoCell") as! JHInspectInfoCell
            if let infoArr = dataArray.first as? [CheckerBaseVM]{
                cell.model = infoArr[indexPath.row]
                var text = ""
                if indexPath.row == 2 {
                    text = "本年度第\(infoModel?.yearTimes ?? 0)次检查"
                }
                cell.subLab.text = text
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHThirdStepCell") as! JHThirdStepCell
            if let infoArr = dataArray[indexPath.section] as? [AddInsOptModel]{
                cell.model = infoArr[indexPath.row]
            }
            return cell
        }
        
        if indexPath.section == 2 {
            if var signArr = dataArray[2] as? [CheckEditCellVM]{
                let model = signArr[indexPath.row]
                let cellId = model.type == .note ? "CheckNoteCell":"CheckSignCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CheckEditBaseCell
                cell.model = model
                cell.actionHandler = {[weak self] vm in
                    guard let wf = self, let vv = vm else { return }
                    signArr = signArr.compactMap{[weak self] item in
                        guard let wf = self else { return nil }
                        var mm = item
                        if vv == mm {
                            if vv.type == .note {
                                mm.note = vv.note
                                wf.addModel.record?.remark = vv.note
                            }
                            if vv.type == .sign {
                                mm.picture = vv.picture
                                wf.addModel.record?.inspectSignature = vv.picture
                            }
                        }
                        return mm
                    }
                    wf.dataArray[2] = signArr
                    wf.addModel.toArchive()
                    wf.tableView.reloadData()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if let infoArr = dataArray[indexPath.section] as? [AddInsOptModel]{
                let model = infoArr[indexPath.row]
                let detail = InsOptDetailViewController()
                detail.insOptId = model.inspectOptionId
                navigationController?.pushViewController(detail, completion: nil)
            }
        }
    }
}
