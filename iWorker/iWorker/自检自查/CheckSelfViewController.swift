//
//  CheckSelfViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import MBProgressHUD
import SwiftyJSON

class CheckSelfViewController: JHSelCheckBaseController {

    var inspectInfoModel:InspectInfoModel?
    var typeId = "00000000-0000-0000-0000-000000000000"
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func refreshLocationUI(location: JHLocation) {
        super.refreshLocationUI(location: location)
        addrLab.refresh(icon: "Inspect地址", text: location.desc)
    }
    
    override func loadData() {
        super.loadData()
        let param:[String:Any] = ["commonParam":["appId":JHBaseInfo.appID,
                                                 "userId": JHBaseInfo.userID,
                                                 "storeId":storeId
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc/GetInfoToSelfInspect")
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
                guard let info:InspectInfoModel =  InspectInfoModel.parsed(data: rawData) else { return }
                info.toArchive()
                weakSelf.refreshUIData(model: info)
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
    
    func refreshUIData(model:InspectInfoModel) {
        inspectInfoModel = model
        nameLab.refresh(icon: "Inspect姓名", text: model.userName ?? "")
        iconView.kf.setImage(with: URL(string: model.userIcon), placeholder: UIImage(named: "Inspect全通过"))
        guard var first = dataArray.first else { return }
        guard var third = dataArray.last else { return }
        first.value = model.storeName
        third.value = "本年度第\(model.yearTimes ?? 0)次检查"
        dataArray[0] = first
        dataArray[2] = third
        tableView.reloadData()
    }
    
    override func nextStepAction() {
        super.nextStepAction()
        //TODO: 下一步
        let second = CheckSelfSecondViewController()
        second.storeId = storeId
        second.typeId = typeId
        navigationController?.pushViewController(second, animated: true)
    }
    
    //MARK: - UI
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤1")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JHInspectInfoCell.self, forCellReuseIdentifier: "JHInspectInfoCell")
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame.size.height = height
        tableView.tableHeaderView = headerView
        
        // 虚线设置
        headerView.layoutIfNeeded()
        vline.refresh(isHorizontal: false, lineColor: .initWithHex("BB9881"))
        userView.drawDottedLine(userView.bounds, 10, .initWithHex("BB9881"))
    }

    lazy var headerView: UIView = {
        let header = UIView()
        
        header.addSubview(userView)
        userView.snp.makeConstraints { make in
            make.height.equalTo(134)
            make.left.top.equalTo(15)
            make.width.equalTo(kScreenWidth - 30)
            make.center.equalToSuperview()
        }
        return header
    }()
    
    lazy var userView: JHSquareView = {
        let info = JHSquareView()
        info.backgroundColor = .initWithHex("FBF9EC")
        
        info.addSubviews([iconView,vline,nameLab,timeLab,addrLab])
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        vline.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.top.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(vline.snp.right).offset(10)
            make.right.equalTo(-10)
        }
        
        timeLab.snp.makeConstraints { make in
            make.top.equalTo(nameLab.snp.bottom).offset(15)
            make.leading.trailing.equalTo(nameLab)
        }
        
        addrLab.snp.makeConstraints { make in
            make.top.equalTo(timeLab.snp.bottom).offset(15)
            make.leading.trailing.equalTo(nameLab)
        }
        
        return info
    }()
    
    lazy var iconView: UIImageView = {
        let imgView = UIImageView(image: .init(named: "Inspect全通过"))
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    lazy var vline: JHLineImageView = {
        let view = JHLineImageView()
        return view
    }()
    
    lazy var nameLab: JHIconLabel = {
        let lab = JHIconLabel(icon: "Inspect姓名")
        return lab
    }()
    lazy var timeLab: JHIconLabel = {
        let lab = JHIconLabel(icon: "Inspect时间", text: today)
        return lab
    }()
    lazy var addrLab: JHIconLabel = {
        let lab = JHIconLabel(icon: "Inspect地址")
        return lab
    }()
    
    lazy var dataArray: [CheckerBaseVM] = {
        var type = "请选择"
        if let itype = addModel.record?.selfInspectType{
            type = itype
        }
        let data = [CheckerBaseVM(icon: "Inspect经营者名称", name: "经营者名称", value: ""),
                    CheckerBaseVM(icon: "Inspect自查类型", name: "自查类型", value: type),
                    CheckerBaseVM(icon: "Inspect检查次数", name: "检查次数", value: "")
        ]
        return data
    }()
}

extension CheckSelfViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JHInspectInfoCell") as! JHInspectInfoCell
        cell.model = dataArray[indexPath.row]
        var right = -20
        cell.accessoryType = .none
        if indexPath.row == 1 {
            right = -5
            cell.accessoryType = .disclosureIndicator
        }
        cell.valueLab.snp.updateConstraints { make in
            make.right.equalTo(right)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            //TODO: 切换检查类型 日检/周检
            guard let typelist = inspectInfoModel?.inspectTypeList else { return }
            var btns = typelist.compactMap { inspectType -> String? in
                inspectType.text
            }
            var types = typelist.compactMap { inspectType -> UIAlertAction.Style? in
                UIAlertAction.Style.default
            }
            btns.append("取消")
            types.append(.cancel)
            UIAlertController.showDarkSheet(btns: btns, types: types) {[weak self] row in
                //TODO: 选择自检类型
                guard let wf = self else { return }
                if row == btns.count - 1 { return } //取消按钮
                var typecell = wf.dataArray[1]
                typecell.value = btns[row]
                wf.dataArray[1] = typecell
                wf.tableView.reloadData()
                //
                guard let typelist = wf.inspectInfoModel?.inspectTypeList else { return }
                let typeM = typelist[row]
                guard let typeId = typeM.id else { return }
                wf.typeId = typeId
                wf.addModel.record?.selfInspectType = typeM.text
                wf.addModel.record?.selfInspectTypeId = typeId
                wf.addModel.toArchive()
            }
        }
    }
}
