//
//  ReportUserInfoMapView.swift
//  iWorker
//
//  Created by boyer on 2022/5/25.
//

import Foundation
import UIKit
import JHBase

class ReportUserInfoMapView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        let line = UIView()
        line.backgroundColor = .kEEEEEE
        
        addSubviews([infoView,line,tableView])
        infoView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    let icon = UIImageView()
    let name = UILabel()
    let tel = UILabel()
    let tasknum = UILabel()
    let checknum = UILabel()
    let lasttime = UILabel()
    
    var dataM:ReportMapUserTaskStatM?{
        didSet{
            guard let data = dataM else{return}
            icon.kf.setImage(with: URL(string: data.employeeInfo.employeeHeadIcon), placeholder: UIImage(named:"vatoricon"))
            name.text = data.employeeInfo.employeeName
            tel.text = data.employeeInfo.employeeID
            tasknum.attributedText = arrtext(text: "任务数：\(data.waitCheck)/\(data.all)")
            checknum.attributedText = arrtext(text: "带检查：\(data.checked)")
            lasttime.text = "最后上传时间：2019-08-09"
        }
    }
    
    func arrtext(text:String)->NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                    .foregroundColor: UIColor(hexString: "2F3856")!]
        
        attrString.addAttributes(attr,
                                 range: NSRange(location: 0, length: attrString.length))
        
        let strSubAttr1: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                                 .foregroundColor: UIColor(hexString: "99A0B6")!]
        attrString.addAttributes(strSubAttr1, range: NSRange(location: 0, length: 4))
        return attrString
    }
    
    lazy var infoView: UIView = {
        
        let info = UIView()
        
        icon.layer.cornerRadius = 18
        icon.layer.masksToBounds = true
        
        name.font = .systemFont(ofSize: 15)
        name.textColor = .initWithHex("2F3856")
        
        tel.font = .systemFont(ofSize: 12)
        tel.textColor = .initWithHex("99A0B6")
        
        lasttime.font = .systemFont(ofSize: 12)
        lasttime.textColor = .initWithHex("99A0B6")
        
        info.addSubviews([icon,name,tel,tasknum,checknum,lasttime])
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top)
            make.left.equalTo(icon.snp.right).offset(8)
        }
        
        tel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.bottom.equalTo(icon.snp.bottom)
        }
        
        tasknum.snp.makeConstraints { make in
            make.right.equalTo(-32)
            make.centerY.equalTo(name.snp.centerY)
        }
        
        checknum.snp.makeConstraints { make in
            make.leading.equalTo(tasknum.snp.leading)
            make.right.equalTo(-32)
            make.centerY.equalTo(tel.snp.centerY)
        }
        
        lasttime.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.bottom.equalTo(-15)
        }
        
        return info
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.dataSource = self
        tb.isScrollEnabled = false
        tb.backgroundColor = .white
        tb.register(ReportUserTaskCell.self, forCellReuseIdentifier: "ReportUserTaskCell")
        tb.separatorColor = .kEEEEEE
        tb.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 9, right: 12)
        tb.tableFooterView = UIView()
        tb.estimatedSectionFooterHeight = 100
        tb.rowHeight = UITableView.automaticDimension
        return tb
    }()
}

extension ReportUserInfoMapView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = dataM else{return 0}
        return data.taskList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReportUserTaskCell = tableView.dequeueReusableCell(withIdentifier: "ReportUserTaskCell") as! ReportUserTaskCell
        guard let data = dataM else{return UITableViewCell()}
        cell.model = data.taskList[indexPath.row]
        return cell
    }
}
