//
//  CheckReportViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class CheckReportViewController: JHSelCheckBaseController {

    var reportId = ""
    var report: CheckReportModel?
    var dataArray:[[Any]] = []
    var api = "GetSelfInspectReformInfo" //整改
    lazy var reform: ReformInfoModel = {
        var model = ReformInfoModel()
        model.record = ReformRecordModel(id: reportId,
                                         appId: JHBaseInfo.appID,
                                         waterMark: "", isComplete: true)
        
        return model
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect报告bar")
        navTitle = "检查报告"
        bottomBtn.setTitle("保存", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JHInspectInfoCell.self, forCellReuseIdentifier: "JHInspectInfoCell")
        tableView.register(JHReformOptCell.self, forCellReuseIdentifier: "JHReformOptCell")
        tableView.register(CheckNoteCell.self, forCellReuseIdentifier: "CheckNoteCell")
        tableView.register(CheckSignCell.self, forCellReuseIdentifier: "CheckSignCell")
    }
    
    override func nextStepAction() {
        //TODO: 保存
        //校验
        guard let optArr = dataArray[1] as? [ReformOptionModel] else {return}
        let tmpOptArr = optArr.filter{item in
            if let tmp1 = item.signature, !tmp1.isEmpty, let tmp2 = item.remark, !tmp2.isEmpty {return false}else{return true}
        }
        if let opt = tmpOptArr.first {
            VCTools.toast("请完成\(opt.text ?? "")")
            return
        }
        
        guard let signArr = dataArray[2] as? [CheckEditCellVM] else {return}
        let tmpSignArr = signArr.filter{$0.note.isEmpty || $0.picture.isEmpty}
        if let note = tmpSignArr.first {
            VCTools.toast("请完成\(note.desc)")
            return
        }
        
        //检查项签字
        reform.options = report?.insOpts?.compactMap{ item -> ReformOptModel? in
            ReformOptModel(inspectOptionId: item.id, inspectSignature: item.signature, remark: item.remark)
        }
        // 签字
        reform.signatures = report?.reformSignature?.compactMap{ model -> ReformSignModel? in
            var tmp = model
            if let arr = dataArray[2] as? [CheckEditCellVM]{
                let note = arr.filter{$0.role == tmp.roleName && $0.type == .note}
                let sign = arr.filter{$0.role == tmp.roleName && $0.type == .sign}
                tmp.remark = note.first?.note
                tmp.signature = sign.first?.picture
            }
            return tmp
        }
        
        reform.profiles = [] //五定图片
        let param:[String:Any] = reform.toParams()
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectReformSV.svc/SaveSelfInspectReformInfo")
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
                weakSelf.backBtnClicked(UIButton())
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
    
    override func backBtnClicked(_ btn: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var headerView = JHOptionsHeaderView(name: "未通过检查项", note: "负责人")
    
    func refreshUI(report:CheckReportModel) {
        self.report = report
        let infos = [CheckerBaseVM(icon: "Inspect经营者名称",
                                  name: "经营者名称",
                                  value: report.storeName),
                    CheckerBaseVM(icon: "Inspect自查类型",
                                  name: "自查类型",
                                  value: report.inspectTypeName),
                    CheckerBaseVM(icon: "Inspect检查次数",
                                  name: "检查时间",
                                  value: report.inspectDate),
                    CheckerBaseVM(icon: "Inspect业态类型",
                                  name: "业态类型",
                                  value: report.storeTypeName)
        ]
        
        dataArray.append(infos)
        
        if let opts = report.insOpts {
            dataArray.append(opts)
        }
        let usernote = CheckEditCellVM( type: .note, note: report.remark ?? "", isDetail: true)
        let usersign = CheckEditCellVM(type: .sign, picture: report.signature ?? "", isDetail: true)
        var signArr:[CheckEditCellVM] = [usernote, usersign]
        if let roles = report.reformSignature {
            for vm in roles {
                let role = vm.roleName ?? ""
                let note = vm.remark ?? ""
                let sign = vm.signature ?? ""
                let notevm = CheckEditCellVM(role: role, type: .note, note: note)
                let signvm = CheckEditCellVM(role: role, type: .sign, picture: sign)
                signArr.append(notevm)
                signArr.append(signvm)
            }
            dataArray.append(signArr)
        }
        tableView.reloadData()
    }
    
    override func loadData() {
        let param:[String:Any] = ["commonParam":["appId": JHBaseInfo.appID,
                                                    "Id": reportId]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectReformSV.svc/\(api)")
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
                guard let report:CheckReportModel =  CheckReportModel.parsed(data: rawData) else { return }
                weakSelf.refreshUI(report: report)
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

extension CheckReportViewController:UITableViewDataSource
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
                let text = indexPath.row == 2 ? "本年度第\(report?.yearTimes ?? 0)次检查":""
                cell.subLab.text = text
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHReformOptCell") as! JHReformOptCell
            if let optsArr = dataArray[indexPath.section] as? [ReformOptionModel]{
                cell.model = optsArr[indexPath.row]
                cell.reformHandler = {[weak self] item in
                    guard let wf = self else { return }
                    if var insOpts = wf.dataArray[indexPath.section] as? [ReformOptionModel] {
                        if let index = insOpts.firstIndex(of: item){
                            insOpts[index] = item
                            wf.dataArray[indexPath.section] = insOpts
                            wf.tableView.reloadRows(at: [IndexPath(row: index, section: indexPath.section)], with: .none)
                        }
                    }
                }
            }
            return cell
        }
        
        if indexPath.section == 2 {
            if let signArr = dataArray[2] as? [CheckEditCellVM]{
                let model = signArr[indexPath.row]
                let cellId = model.type == .note ? "CheckNoteCell":"CheckSignCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CheckEditBaseCell
                cell.model = model
                cell.actionHandler = {[weak self] vm in
                    guard let wf = self, let vv = vm else { return }
                    if var arr = wf.dataArray[2] as? [CheckEditCellVM]{
                        arr = arr.compactMap{ item in
                            var mm = item
                            if vv == mm {
                                if vv.type == .note {
                                    mm.note = vv.note
                                }
                                if vv.type == .sign {
                                    mm.picture = vv.picture
                                }
                            }
                            return mm
                        }
                        wf.dataArray[2] = arr
                        wf.tableView.reloadData()
                    }
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, let optsArr = dataArray[1] as? [ReformOptionModel]{
            let model = optsArr[indexPath.row]
            let detail = InsOptDetailViewController()
            detail.insOptId = model.id
            navigationController?.pushViewController(detail, completion: nil)
        }
    }
}
