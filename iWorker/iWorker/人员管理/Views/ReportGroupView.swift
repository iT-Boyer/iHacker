//
//  ReportGroupView.swift
//  iWorker
//
//  Created by boyer on 2022/5/27.
//

import UIKit

struct ReportGroupModel {
    let Id,name:String
    let selected:Bool
}


class ReportGroupLCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titlab = UILabel()
    let icon = UIImageView()
    
    var model:ReportGroupModel?{
        didSet{
            if model != nil {
                titlab.text = model?.name
                var iconName = "selectedicon"
                var textColor:UIColor = .k2CD773
                if model!.selected {
                    iconName = "selecticon"
                    textColor = .k2F3856
                }
                icon.image = .init(named: iconName)
                titlab.textColor = textColor
            }
        }
    }
    
    func createView(){
        titlab.font = .systemFont(ofSize: 15)
        contentView.addSubviews([titlab,icon])
        titlab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(15)
            make.left.equalTo(10)
        }
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
    }
}


class ReportGroupView: UIView {
    
    var dataArray:[ReportGroupModel] = []
    var handlerBlock:(ReportGroupModel)->() = {_ in}
    init() {
        super.init(frame: .zero)
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorColor = .kEEEEEE
        tb.removeTableFooterView()
        tb.estimatedRowHeight = 30
        tb.rowHeight = UITableView.automaticDimension
        tb.register(ReportGroupLCell.self, forCellReuseIdentifier: "ReportGroupLCell")
        return tb
    }()
    
}

extension ReportGroupView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportGroupLCell") as! ReportGroupLCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handlerBlock(dataArray[indexPath.row])
    }
}
