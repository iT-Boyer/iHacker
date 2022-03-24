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
    let infoRows:[DeviceCellStyle] = [.SN, .Scence, .Nick]
    var timeRows:[(String,String)] = []
    var sections:[[Any]]!
    
    var scenes:JHSceneModels!
//    override func callFunc(_ aSelector: String, _ param1: AnyObject? = nil, _ param2: AnyObject? = nil) -> AnyObject? {
//        <#code#>
//    }
    lazy var bindModel: JHDeviceBindModel = {
        return JHDeviceBindModel()
    }()
    
    lazy var sceneVM: JHSceneViewModel = {
        let scene = JHSceneViewModel()
        return scene
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "绑定设备"
        self.view.backgroundColor = UIColor.white
        
        // 数据
        sections = [infoRows,timeRows]
        
        // UI
        createView()
        loadSceneData()
        //空白处隐藏键盘
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: 按钮事件
    // TODO: 绑定设备
    @objc func commitAction() {
        
    }
    // MARK: - UI部署
    func createView() {
        
        //saveBtn
        let saveBtn = UIButton()
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = .initWithHex("599199")
        saveBtn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.layer.cornerRadius = 5
        saveBtn.addTarget(self, action: #selector(commitAction), for: .touchDown)
        
        view.addSubview(self.tableView)
        view.addSubview(saveBtn)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.bottom.equalTo(-JHBase.kEmptyBottomHeight)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .initWithHex("F5F5F5")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(JHDeviceSNCell.self, forCellReuseIdentifier: "JHDeviceSNCell")
        tableview.register(JHDeviceSceneCell.self, forCellReuseIdentifier: "JHDeviceSceneCell")
        tableview.register(JHDeviceNickCell.self, forCellReuseIdentifier: "JHDeviceNickCell")
        tableview.register(JHDeviceTimesCell.self, forCellReuseIdentifier: "JHDeviceTimesCell")
        tableview.separatorColor = .red //.initWithHex("EEEEEE")
        tableview.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableview.tableFooterView = UIView()
        return tableview
    }()
    lazy var headView: UIView = {
        let headView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        headView.backgroundColor = .white
        
        let title = UILabel()
        title.text = "工作时间"
        title.textColor = .initWithHex("2F3856")
        title.font = .systemFont(ofSize: 15, weight: .bold)
        
        let addBtn = UIButton()
        addBtn.setTitle("添加", for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 14)
        addBtn.setTitleColor(.initWithHex("146FD1"), for: .normal)
        addBtn.setImage(.init(named: "addtimelist"), for: .normal)
        addBtn.jh.setHandleClick { button in
            if self.timeRows.count == 10 {
                VCTools.toast("最多添加10条工作时间记录")
            }else{
                let picker = JHDeviceTimePicker()
                picker.timeHandler = { start,end in
                    let time = (start,end)
                    //TODO: 时间选择器
                    self.timeRows.append(time)
                    self.tableView.reloadData()
                }
                self.present(picker, animated: true)
            }
        }
        
        headView.addSubview(title)
        headView.addSubview(addBtn)
        
        title.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        return headView
    }()
}

extension JHBindingEditIntelDescisionVC:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return timeRows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.headView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let style = infoRows[indexPath.row]
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
                sceneCell.bind(self.sceneVM)
            }
            return cell
        }else{
            // 工作时间单元
            let cell:JHDeviceTimesCell = tableView.dequeueReusableCell(withIdentifier: "JHDeviceTimesCell", for: indexPath) as! JHDeviceTimesCell
            let time = timeRows[indexPath.row]
            cell.startTime = time.0
            cell.endTime = time.1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { //设备模块
            let style = infoRows[indexPath.row]
            if style == .Scence {
                showSenceAlert(scenes.content)
            }
        }
    }
    
    // MARK: 侧滑删除逻辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { action, sourceView, completionHandler in
            self.timeRows.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        let configuration = UISwipeActionsConfiguration.init(actions: [deleteAction])
        return configuration
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
                VCTools.toast(msg)
            }
        }
    }
    
    @objc func showSenceAlert(_ list:[JHSceneModel]?) {
        
        guard let scenes = list else {
            return
        }
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .darkText
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
