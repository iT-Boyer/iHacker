//
//  ReformView.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import UIKit
import JHBase
import Viperit
import MBProgressHUD

//MARK: ReformView Class
final class ReformView: ReformBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navTitle = "自改自查"
    }
    
    override func createView() {
        super.createView()
        
        
        navBar.addSubviews([settingBtn, myRecordBtn, storeRecordBtn])
        
        settingBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
        }
        
        storeRecordBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.left.equalTo(settingBtn.snp.right).offset(10)
        }
        
        myRecordBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-12)
            make.left.equalTo(storeRecordBtn.snp.right).offset(10)
        }
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        tb.removeTableFooterView()
        tb.separatorStyle = .singleLine
        tb.estimatedRowHeight = 75
        tb.delegate = self
        tb.dataSource = self
        tb.separatorColor = .initWithHex("A9A9A9")
        tb.separatorInset = .init(top: 0.5, left: 0, bottom: 0, right: 0)
        tb.rowHeight = UITableView.automaticDimension
        if #available (iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.5
        }
        tb.register(ReformTaskCell.self, forCellReuseIdentifier: "ReformTaskCell")
        return tb
    }()
    
    lazy var myRecordBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "gertoj"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.presenter.showMyRecord()
        }
        return btn
    }()
    lazy var storeRecordBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "bustoj"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.presenter.showStoreRecord()
        }
        return btn
    }()
    lazy var settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "set"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.presenter.showSetting()
        }
        return btn
    }()
}

extension ReformView:UITableViewDataSource{
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayData.tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.tableData[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReformTaskCell", for: indexPath)
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let taskCell:ReformTaskCell = cell as? ReformTaskCell else { return }
        guard let currents = displayData.tableData[indexPath.section] else { return }
        let model = currents[indexPath.row]
        taskCell.model = model
    }
}

extension ReformView:UITableViewDelegate{
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: 跳转到拍照页面
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.text = section == 0 ? "     我的自查":"     督办员工自查"
        title.textColor = .k2F3856
        title.font = .systemFont(ofSize: 16, weight: .bold)
        return title
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
}



//MARK: - ReformView API
extension ReformView: ReformViewApi {
    
    func refreshUI(model: BaseModel) {
        if let root = model as? ReformCommonModel{
            displayData.firstArray = root.content
            tableView.reloadData()
        }
    }
    
}

// MARK: - ReformView Viper Components API
private extension ReformView {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
    var displayData: ReformDisplayData {
        return _displayData as! ReformDisplayData
    }
}
