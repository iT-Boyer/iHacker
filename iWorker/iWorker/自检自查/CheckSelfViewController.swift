//
//  CheckSelfViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase

class CheckSelfViewController: JHSelCheckBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func createView() {
        super.createView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckerBaseCell.self, forCellReuseIdentifier: "CheckerBaseCell")
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame.size.height = height
        tableView.tableHeaderView = headerView
        
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
            make.top.equalTo(28)
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
        let lab = JHIconLabel(icon: "Inspect时间")
        return lab
    }()
    lazy var addrLab: JHIconLabel = {
        let lab = JHIconLabel(icon: "Inspect地址")
        return lab
    }()
    
    
    
    lazy var dataArray: [CheckerBaseVM] = {
        let data = [CheckerBaseVM(icon: "Inspect经营者名称", name: "经营者名称", value: "白兔咖啡有限责任公司", type: 0),
                    CheckerBaseVM(icon: "Inspect自查类型", name: "自查类型", value: "请选择", type: 0),
                    CheckerBaseVM(icon: "Inspect检查次数", name: "检查次数", value: "本年度第5次检查", type: 0)
        ]
        return data
    }()
}

extension CheckSelfViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckerBaseCell") as! CheckerBaseCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
}
