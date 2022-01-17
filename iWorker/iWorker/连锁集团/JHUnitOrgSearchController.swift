//
//  JHUnitOrgSearchController.swift
//  iWorker
//
//  Created by boyer on 2022/1/7.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

protocol JHUnitOrgDelegate:NSObject {
    func refeshChainDataWhenAdd()
    func refeshChainDataWhenChange()
}



class JHUnitOrgSearchController: JHUnitOrgBaseViewController {
    
    weak var delegate:JHUnitOrgDelegate?
    var ibSearchBar:StoreDSelSearchBar!
    var selectNumLab:UILabel!
    var searchTxt:String!
    var selectAllBtn:UIButton!
    
    var chainModel:UnitOrgChainModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "搜索页"
        _ = self.searchView
        tableView.register(JHUnitOrgSearchCell.self, forCellReuseIdentifier: "JHUnitOrgSearchCell")
    }
    
    override func loadData() {
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Simple/GetFirmChainList")
        let requestDic = ["appId":JHBaseInfo.appID,
                          "condition":searchTxt ?? "",
                          "pageIndex":1,
                          "pageSize":20] as [String : Any]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { response in
            let json = JSON(response.data!)
            let storeData = try! json["storeList"].rawData()
            self.dataArray = JHUnitOrgBaseModel.parsed(data: storeData)
            hud.hide(animated: false)
            self.tableView.reloadData()
        }
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
    lazy var searchView: UIView = {
        
        var rootView = UIView()
        ibSearchBar = StoreDSelSearchBar(with: "请输入企业名称或社会信用代码", handler: { text in
            //
            self.searchTxt = text
            self.loadData()
        }, clear: {
            //
            self.searchTxt = ""
            if self.dataArray.count > 0{
                self.dataArray.removeAll()
                self.view.addSubview(self.emptyView)
                self.tableView.reloadData()
                self.selectNumLab.text = "已选择0个企业"
                self.selectAllView.isHidden = true
            }
        })
        
        
        ibSearchBar.searchBar.searchTextPositionAdjustment = .init(horizontal: 6, vertical: 0)
        ibSearchBar.searchBar.setPositionAdjustment(.init(horizontal: 10, vertical: 0), for: .search)
        ibSearchBar.searchBar.setPositionAdjustment(.init(horizontal: -10, vertical: 0), for: .clear)
        let searchIcon:UIImage? = .init(named: "searchicon") ?? nil
        let clearIcon:UIImage? = .init(named: "clearicon") ?? nil
        ibSearchBar.searchBar.setImage(searchIcon, for: .search, state: .normal)
        ibSearchBar.searchBar.setImage(clearIcon, for: .clear, state: .normal)
        self.navBar.backBtn.isHidden = true
        self.navBar.addSubview(self.ibSearchBar)
        self.ibSearchBar.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalTo(self.navBar.titleLabel.snp.centerY)
        }
        
        //取消按钮
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = .systemFont(ofSize: 14)
        cancelBtn.setTitleColor(.init(hexString: "333333"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(backBtnClicked(_:)), for: .touchDown)
        self.navBar.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(54)
            make.left.equalTo(self.ibSearchBar.snp.right)
            make.centerY.equalTo(self.navBar.titleLabel.snp.centerY)
        }
        
        
        return rootView
    }()
    
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
    func selectAllAction(_ btn:UIButton) {
        btn.isSelected = !btn.isSelected
        for model in self.dataArray {
            model.selected = btn.isSelected
        }
        if btn.isSelected {
            self.selectNumLab.text = "已选择\(self.dataArray.count)个企业"
        }else{
            self.selectNumLab.text = "已选择0个企业"
        }
        self.tableView.reloadData()
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
        let cell:JHUnitOrgSearchCell = tableView.dequeueReusableCell(withIdentifier: "JHUnitOrgSearchCell")! as! JHUnitOrgSearchCell
        let model = dataArray[indexPath.section]
        cell.model = model
        if (cell.SelecteAction == nil) {
            cell.SelecteAction = { mod in
                if self.isAddChild {
                    if mod.selected == false {
                        self.selectAllBtn.isSelected = false
                    }
                }else{
                    for org in self.dataArray {
                        org.selected = false
                    }
                    mod.selected = true
                }
                //
                let select = self.dataArray.filter {($0.selected ?? false)}
                self.selectNumLab.text = "已选择\(select.count)个企业"
                tableView.reloadData()
            }
        }
        return cell
    }
}
