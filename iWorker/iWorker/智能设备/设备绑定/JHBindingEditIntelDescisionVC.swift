//
//  JHBindingEditIntelDescisionVC.swift
//  iWorker
//
//  Created by boyer on 2022/3/17.
//
import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

enum DeviceCellStyle {
    case SN
    case Scence
    case Nick
}

extension JHBaseNavVC{
    
    func hideKeyboardWhenTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: 隐藏键盘
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}

class JHBindingEditIntelDescisionVC: JHBaseNavVC{
    
    var storeId:String = ""
    var SN:String = ""
    // UI样式排序
    let rows:[DeviceCellStyle] = [.SN, .Scence, .Nick]
    var scenes:JHSceneModels!
    lazy var sceneVM: JHSceneViewModel = {
        let scene = JHSceneViewModel()
        return scene
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "绑定设备"
        self.view.backgroundColor = UIColor.white
        self.hideKeyboardWhenTappedAround()
        createView()
        loadSceneData()
    }
    
    func createView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(JHDeviceSNCell.self, forCellReuseIdentifier: "JHDeviceSNCell")
        tableview.register(JHDeviceSceneCell.self, forCellReuseIdentifier: "JHDeviceSceneCell")
        tableview.register(JHDeviceNickCell.self, forCellReuseIdentifier: "JHDeviceNickCell")
        tableview.separatorColor = .red //.initWithHex("EEEEEE")
        tableview.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableview
    }()
}

extension JHBindingEditIntelDescisionVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = rows[indexPath.row]
        var cellID = ""
        switch style {
        case .SN:
            cellID = "JHDeviceSNCell"
        case .Scence:
            cellID = "JHDeviceSceneCell"
        case .Nick:
            cellID = "JHDeviceNickCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if cell.isKind(of: JHDeviceSceneCell.self) {
            let sceneCell:JHDeviceSceneCell = cell as! JHDeviceSceneCell
            sceneCell.sceneBtn.addTarget(self, action: #selector(showSenceAlert(_:)), for: .touchDown)
            sceneCell.bind(self.sceneVM)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选择事件----")
        let style = rows[indexPath.row]
        if style == .Scence {
            showSenceAlert(scenes.content)
        }
    }
}

extension JHBindingEditIntelDescisionVC
{
    //获取场景数据
    func loadSceneData() {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/IOTDeviceScene/GetIOTDeviceSceneList")
        let requestDic = ["StoreId":storeId, "SN": SN]
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                weakSelf.scenes = JHSceneModels.parsed(data: data)
                weakSelf.showSenceAlert(weakSelf.scenes.content)
            }else{
                //TODO: 邀请码失效提示
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(msg)
            }
        }
    }
    
    @objc func showSenceAlert(_ list:[JHSceneModel]?) {
        
        guard let scenes = list else {
//            MBProgressHUD.display(<#T##self: UIView##UIView#>)
            return
        }
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .black
        _ = scenes.map { scene in
            let action = UIAlertAction(title: scene.iotSceneName, style: .default) { [weak self] action in
                guard let weakSelf = self else { return }
                //TODO: 切换场景
                weakSelf.sceneVM.sceneName = scene.iotSceneName
            }
            alertVC.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemBlue, forKey: "_titleTextColor")
        
        alertVC.addAction(cancel)
        self.present(alertVC, animated: false)
    }
}
