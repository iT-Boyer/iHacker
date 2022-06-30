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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JHInspectInfoCell.self, forCellReuseIdentifier: "JHInspectInfoCell")
        tableView.register(JHInspectBaseCell.self, forCellReuseIdentifier: "JHInspectBaseCell")
    }
    
    lazy var headerView: UIView = {
        let header = UIView()
        let icon = UIImageView(image: .init(named: "Inspect检查项"))
        let title = UILabel()
        title.text = "检查项"
        title.textColor = .k333333
        title.font = .systemFont(ofSize: 15)
        let line = UIView()
        line.backgroundColor = .initWithHex("A9A9A9")
        header.addSubviews([icon, title, line])
        icon.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalTo(icon.snp.centerY)
        }
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.right.left.bottom.equalToSuperview()
        }
        return header
    }()
    
    
    lazy var dataArray:[[Any]] = [infoArray,optionsArray] as [[Any]]
    
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
}

extension CheckSelfThirdViewController:UITableViewDelegate,UITableViewDataSource
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
        return UITableViewCell()
    }
}
