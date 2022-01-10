//
//  JHUnitOrgSearchController.swift
//  iWorker
//
//  Created by boyer on 2022/1/7.
//

import UIKit

protocol JHUnitOrgDelegate:NSObject {
    func refeshChainDataWhenAdd()
    func refeshChainDataWhenChange()
}



class JHUnitOrgSearchController: JHUnitOrgBaseViewController {
    
    weak var delegate:JHUnitOrgDelegate?
    var ibSearchBar:UISearchBar!
    var selectNumLab:UIView!
    var searchTxt:String!
    var selectAllBtn:UIButton!
    
    var chainModel:UnitOrgChainModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "搜索页"
        dataArray = ["2","2","2","2"]
        tableView.register(JHUnitOrgSearchCell.self, forCellReuseIdentifier: "JHUnitOrgSearchCell")
    }
    
    override func createView() {
        super.createView()
        self.view.addSubview(selectAllView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        selectAllView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    //MARK: getter
    lazy var selectAllView = { () -> UIView in
        var rootView = UIView()
        rootView.backgroundColor = .white
        rootView.isHidden = false //true
        let all = UIButton()
        self.selectAllBtn = all
        all.setImage(.init(named: "unitorgselect"), for: .normal)
        all.setImage(.init(named: "unitorgselected"), for: .selected)
        all.addTarget(self, action: #selector(selectAllAction(_:)), for: .touchDown)
        let lab = UILabel()
        self.selectNumLab = lab
        lab.text = "已选择0个企业"
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .init(hexString: "333333")
        let commit = UIButton()
        commit.titleLabel?.font = .systemFont(ofSize: 16)
        commit.setTitleColor(.white, for: .normal)
        commit.setTitle("确认加入", for: .normal)
        commit.backgroundColor = .init(hexString: "04A174")
        commit.layer.cornerRadius = 15
        commit.layer.masksToBounds = true
        commit.addTarget(self, action: #selector(commitAction(_:)), for: .touchDown)
        
        rootView.addSubview(all)
        rootView.addSubview(lab)
        rootView.addSubview(commit)
        all.imageEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 12)
        var allsize = CGSize(width: 18, height: 0)
        all.isHidden = true
        if self.isAddChild {
            all.isHidden = false
            allsize = CGSize(width: 22+30, height: 22+22)
        }
        
        all.snp.makeConstraints { make in
            make.size.equalTo(allsize)
            make.centerY.equalToSuperview()
            make.left.equalTo(6)
        }
        lab.snp.makeConstraints { make in
            make.left.equalTo(all.snp.right)
            make.centerY.equalToSuperview()
        }
        commit.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 96, height: 30))
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
        }
        return rootView
    }()
    @objc
    func selectAllAction(_ but:UIButton) {
        
    }
    @objc
    func commitAction(_ btn:UIButton) {
        
    }
}

extension JHUnitOrgSearchController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "JHUnitOrgSearchCell")!
        cell.textLabel?.text = "sdf"
        return cell
    }
}
