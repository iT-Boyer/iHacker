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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //归档
        addModel.toArchive()
    }
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤2")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(JHInspectBaseCell.self, forCellReuseIdentifier: "JHInspectBaseCell")
        headerView.frame.size.height = 60
        tableView.tableHeaderView = headerView
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
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

extension CheckSelfSecondViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JHInspectBaseCell") as! JHInspectBaseCell
        cell.model = dataArray[indexPath.row]
        cell.actionHandler = {[weak self] model in
            guard let wf = self else { return }
            wf.dataArray =  wf.dataArray.compactMap{ item in
                var mm = item
                if model?.inspectOptionId == mm.inspectOptionId {
                    mm.status = model?.status
                }
                return mm
            }
            wf.addModel.options = wf.dataArray
            wf.tableView.reloadData()
        }
        return cell
    }
}
