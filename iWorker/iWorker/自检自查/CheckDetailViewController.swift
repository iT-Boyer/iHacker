//
//  CheckDetailViewController.swift
//  iWorker
//
//  Created by boyer on 2022/7/7.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class CheckDetailViewController: CheckReportViewController {

    override func viewDidLoad() {
        api = "GetSelfInspectDetailInfo"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var headerView: JHOptionsHeaderView{
        set{}
        get{JHOptionsHeaderView(name: "检查项", note: "")}
    }
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤3")
        navTitle = "自检自查"
        
        tableView.removeTableFooterView()
        tableView.register(JHThirdStepCell.self, forCellReuseIdentifier: "JHThirdStepCell")
        
        
        navBar.addSubview(inspectBtn)
        inspectBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 50))
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-10)
        }
    }
    
    lazy var inspectBtn: UIButton = {
        let inspect = UIButton()
        inspect.setImage(.init(named: "Inspect详情"), for: .normal)
        inspect.imageEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 0)
        inspect.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 整改详情
            let reform = JHReportDetailController()
            reform.reportId = wf.reportId
            wf.navigationController?.pushViewController(reform)
        }
        return inspect
    }()
    
    override func backBtnClicked(_ btn: UIButton) {
        navigationController?.popViewController()
    }
    
    override func refreshUI(report: CheckReportModel) {
        super.refreshUI(report: report)
        let notevm = CheckEditCellVM( type: .note, note: report.remark ?? "", isDetail: true)
        let signvm = CheckEditCellVM(type: .sign, picture: report.signature ?? "", isDetail: true)
        dataArray[2] = [notevm, signvm]
        if let five = report.authUserProfile {
            fiveFirstView.kf.setImage(with: URL(string: five.first))
            fiveSecondView.kf.setImage(with: URL(string: five.last))
        }
        inspectBtn.isHidden = !(report.isReform ?? false)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JHThirdStepCell") as! JHThirdStepCell
            if let optsArr = dataArray[indexPath.section] as? [ReformOptionModel]{
                let reform = optsArr[indexPath.row]
                let origin = InspectOptionModel(id: reform.id, isNeedPic: false, isNotForAll: false, text: reform.text)
                let model = AddInsOptModel(inspectOptionId: reform.id,
                                           picture: reform.pics,
                                           status: reform.status,
                                           origin: origin)
                cell.model = model
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
}
