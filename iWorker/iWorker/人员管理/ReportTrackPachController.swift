//
//  ReportTrackPachController.swift
//  iWorker
//
//  Created by boyer on 2022/5/23.
//

import JHBase
import UIKit
import SwiftyJSON
import MBProgressHUD

class ReportTrackPachController: JHBaseNavVC {
    
    var userId = ""
    var dateStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "足迹点"
        createView()
        if dateStr.count == 0 {
            dateStr = today
        }
        loadData(by: dateStr)
    }
    
    func createView() {
        //导航条右边按钮
        let create = UIButton()
        create.setImage(.init(named: "chooseTime"), for: .normal)
        create.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.navigationController?.present(wf.picker, animated: true)
        }
        
        navBar.addSubview(create)
        create.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    lazy var infoView: UIView = {
        let info = UIView()
        info.backgroundColor = .white
        info.addSubviews([icon,nameLab,idLab,dateLab])
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(10)
            make.left.equalTo(12)
            make.bottom.equalTo(-10)
        }
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top)
            make.left.equalTo(icon.snp.right).offset(8)
        }
        idLab.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.bottom.equalTo(icon.snp.bottom)
        }
        dateLab.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(nameLab.snp.centerY)
        }
        return info
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 18
        icon.layer.masksToBounds = true
        return icon
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        lab.textColor = .k2F3856
        return lab
    }()
    
    lazy var idLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .k99A0B6
        return lab
    }()
    
    lazy var dateLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .k99A0B6
        return lab
    }()
    
    lazy var picker: JHTimePicker = {
        let time = JHTimePicker()
        time.timeHandler = {[weak self] result in
            guard let wf = self else {return}
            let format = DateFormatter()
            format.dateFormat = "YYYY-MM-dd"
            let date = format.string(from: result)
            wf.loadData(by: date)
        }
        return time
    }()
    var dataArray: [ReportLocationM] = []
    var today: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let now = NSDate() as Date
        let time = format.string(from: now)
        return time
    }
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .white
        tb.dataSource = self
        tb.removeTableFooterView()
        tb.estimatedRowHeight = 40
        tb.separatorStyle = .none
        tb.rowHeight = UITableView.automaticDimension
        tb.register(ReportTrackPathCell.self, forCellReuseIdentifier: "ReportTrackPathCell")
        let v = infoView
        let height = infoView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        v.frame.size.height = height
        tb.tableHeaderView = v
        return tb
    }()
    
    func loadData(by date:String) {
        let param:[String:Any] = ["UserId":userId,
                                  "AppId":JHBaseInfo.appID,
                                  "ReportDate":date,
                                  ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionFootPrint/v3/GetDayFootPrint")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsCompleted"].boolValue
            if result {
                guard let rawData = try? json["Data"].rawData() else {return}
                guard let trackPach:ReportTrackPachM =  ReportTrackPachM.parsed(data: rawData) else { return }
                // info
                weakSelf.nameLab.text = trackPach.userName
                weakSelf.idLab.text = "ID：\(trackPach.userTel)"
                weakSelf.dateLab.text = weakSelf.dateStr
                
                weakSelf.icon.kf.setImage(with: URL(string: trackPach.userHeadIcon), placeholder: UIImage(named:"vatoricon"))
                
                weakSelf.dataArray = trackPach.locationList
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}

extension ReportTrackPachController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReportTrackPathCell = tableView.dequeueReusableCell(withIdentifier: "ReportTrackPathCell") as! ReportTrackPathCell
        cell.model = dataArray[indexPath.row]
        cell.line.topView.isHidden = indexPath.row == 0
        cell.line.bottomView.isHidden = indexPath.row == dataArray.count - 1
        return cell
    }
}
