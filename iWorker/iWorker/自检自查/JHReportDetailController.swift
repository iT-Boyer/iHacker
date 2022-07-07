//
//  JHReportDetailController.swift
//  iWorker
//
//  Created by boyer on 2022/7/7.
//

import UIKit

class JHReportDetailController: CheckReportViewController {

    override func viewDidLoad() {
        api = "GetSelfInspectReformDetailInfo"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func createView() {
        super.createView()
        
        tableView.removeTableFooterView()
        
        let inspectBtn = UIButton()
        inspectBtn.setImage(.init(named: "Inspect详情"), for: .normal)
        inspectBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 0)
        inspectBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            let third = CheckDetailViewController()
            third.reportId = wf.reportId
            wf.navigationController?.pushViewController(third)
        }
        navBar.addSubview(inspectBtn)
        inspectBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 50))
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-10)
        }
    }
    
    override func refreshUI(report: CheckReportModel) {
        super.refreshUI(report: report)
        let usernote = CheckEditCellVM( type: .note, note: report.remark ?? "", isDetail: true)
        let usersign = CheckEditCellVM(type: .sign, picture: report.signature ?? "", isDetail: true)
        var signArr:[CheckEditCellVM] = [usernote, usersign]
        if let roles = report.reformSignature {
            for vm in roles {
                let role = vm.roleName ?? ""
                let note = vm.remark ?? ""
                let sign = vm.signature ?? ""
                let notevm = CheckEditCellVM(role: role, type: .note, note: note, isDetail: true)
                let signvm = CheckEditCellVM(role: role, type: .sign, picture: sign, isDetail: true)
                signArr.append(notevm)
                signArr.append(signvm)
            }
            dataArray[2] = signArr
        }
        if let five = report.authUserProfile {
            fiveFirstView.kf.setImage(with: URL(string: five.first))
            fiveSecondView.kf.setImage(with: URL(string: five.last))
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHReformOptCell") as! JHReformOptCell
            if let optsArr = dataArray[indexPath.section] as? [ReformOptionModel]{
                cell.model = optsArr[indexPath.row]
                cell.isDetail = true
            }
            return cell
        }
        
        if indexPath.section == 2 {
            if let signArr = dataArray[2] as? [CheckEditCellVM]{
                let model = signArr[indexPath.row]
                let cellId = model.type == .note ? "CheckNoteCell":"CheckSignCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CheckEditBaseCell
                cell.model = model
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func backBtnClicked(_ btn: UIButton) {
        navigationController?.popViewController()
    }
}
