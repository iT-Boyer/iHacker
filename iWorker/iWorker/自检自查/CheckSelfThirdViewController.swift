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
        tableView.register(JHInspectBaseCell.self, forCellReuseIdentifier: "JHInspectBaseCell")
        tableView.register(CheckNoteCell.self, forCellReuseIdentifier: "CheckNoteCell")
        tableView.register(CheckSignCell.self, forCellReuseIdentifier: "CheckSignCell")
    }
    
    override func nextStepAction() {
        super.nextStepAction()
        let report = CheckReportViewController()
        navigationController?.pushViewController(report, animated: true)
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
                                  value: info.storeName,
                                  type: 0),
                    CheckerBaseVM(icon: "Inspect自查类型",
                                  name: "自查类型",
                                  value: type,
                                  type: 0),
                    CheckerBaseVM(icon: "Inspect检查次数",
                                  name: "检查时间",
                                  value: today,
                                  type: 1),
                    CheckerBaseVM(icon: "Inspect业态类型",
                                  name: "业态类型",
                                  value: info.storeTypeName,
                                  type: 0)
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
        let notevm = CheckEditCellVM(desc: "备注", type: .checker)
        let signvm = CheckEditCellVM(desc: "检查人签名", type: .checkerSign)
        let notevm1 = CheckEditCellVM(desc: "食品安全管理员意见", type: .manager)
        let signvm1 = CheckEditCellVM(desc: "食品安全管理员签字", type: .managerSign)
        let notevm2 = CheckEditCellVM(desc: "法人代表(负责人)意见", type: .owner)
        let signvm2 = CheckEditCellVM(desc: "法人代表(负责人)签字", type: .ownerSign)
        return [notevm, signvm, notevm1, signvm1, notevm2, signvm2]
    }()
    
    lazy var headerView = JHOptionsHeaderView(name: "检查项")
}

extension CheckSelfThirdViewController:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            //
            return dataArray[section].count - 4
        }
        return dataArray[section].count
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
                if cell.model?.type == 1 {
                    cell.subLab.text = "本年度第\(infoModel?.yearTimes ?? 0)次检查"
                }
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHInspectBaseCell") as! JHInspectBaseCell
            if let infoArr = dataArray[indexPath.section] as? [AddInsOptModel]{
                cell.model = infoArr[indexPath.row]
            }
            return cell
        }
        
        if indexPath.section == 2 {
            if let signArr = dataArray[2] as? [CheckEditCellVM]{
                let model = signArr[indexPath.row]
                var cellId = "CheckNoteCell"
                switch model.type {
                case .checkerSign, .managerSign, .ownerSign:
                    cellId = "CheckSignCell"
                default:
                    cellId = "CheckNoteCell"
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CheckEditBaseCell
                cell.model = model
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
