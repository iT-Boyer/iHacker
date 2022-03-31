//
//  JHBindingEditIntelDescisionVC.swift
//  iWorker
//
//  Created by boyer on 2022/3/17.
//
import UIKit
import JHBase
import Alamofire
import SwiftyJSON
import MBProgressHUD

// 页面支持的三种场景
enum PageActionType {
    case bind   //绑定新设备
    case edit   //编辑更新设备
    case scanBind   //支持首页地图扫一扫自动提交功能
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
    //默认为绑定功能
    var pageType = PageActionType.bind
    var storeId = "00000000-0000-0000-0000-000000000000"
    var SN = ""
    // UI样式排序
    let infoRows:[DeviceCellStyle] = [.SN, .Scence, .Nick]
    var timeRows:[(String,String)] = []
    var sections:[[Any]]!
    // 场景接口数据
    var scenes:JHSceneModels!{
        didSet{
            scenes.sn = snVM.SNCode
        }
    }
    //角色：
    lazy var isPersonal: Bool = {
        let person = storeId.hasPrefix("00000000") || storeId.count == 0
        return person
    }()

    lazy var bindModel: JHDeviceBindModel = {
        var model = JHDeviceBindModel()
        model.storeId = storeId
        return model
    }()
    
    // ViewModel
    lazy var snVM:JHSNViewModel = {
        let sn = JHSNViewModel()
        sceneVM.bindSN(sn)
        nickVM.bindSN(sn)
        nickVM.bindScence(sceneVM)
        return sn
    }()
    lazy var sceneVM = JHSceneViewModel()
    lazy var nickVM = JHNickViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "绑定设备"
        self.view.backgroundColor = UIColor.white
        
        // 数据
        sections = [infoRows,timeRows]
        
        // UI
        createView()
        //空白处隐藏键盘
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: 按钮事件
    // TODO: 绑定设备
    @objc func commitAction() {
        //TODO: 校验
        guard let sncode = snVM.SNCode, sncode.count > 0 else {
            VCTools.toast("请输入设备SN号")
            return
        }
        guard let scence = sceneVM.sceneModel else {
            VCTools.toast("请选择设备场景类型")
            return
        }
        guard nickVM.value.count > 0 else {
            VCTools.toast("请输入设备名称")
            return
        }
        
        bindModel.sn = sncode
        bindModel.name = nickVM.value
        bindModel.deviceType = scence.hardWareDeviceKey
        bindModel.deviceTypeID = scence.iotSceneID
        bindModel.deviceTypeName = scence.iotSceneMonitorName
        //时间
        timeRows.forEach { (start, end) in
            let time = WorkTime.init(endTime: start, startTime: end)
            bindModel.workTimeList?.append(time)
        }
        submit()
    }
    
    @objc static func scanBind(_ sn:String) {
        let page = JHBindingEditIntelDescisionVC()
        page.pageType = .scanBind
        page.SN = sn
        page.snVM.SNCode = sn
        page.loadSceneData()
    }
    
    @objc func scanBind2(_ sn:String) {
        pageType = .scanBind
        SN = sn
        snVM.SNCode = sn
        loadSceneData()
    }
    
    @objc func showSenceAlert(_ list:[JHSceneModel]?) {
        //
        guard let scenes = list else {
            return
        }
        if pageType == .scanBind {
            pageType = .bind //重置状态
            if scenes.count == 1 {
                //TODO: 自动绑定
                //初始化数据
                sceneVM.sceneModel = scenes.first
                commitAction()
            }else{
                self.modalPresentationStyle = .fullScreen
                UIViewController.topVC?.present(self, animated: true, completion: {
                    //初始化数据，上屏
                    self.snVM.value = self.SN
                })
            }
            return
        }else {
            if scenes.count == 1 {
                sceneVM.sceneModel = scenes.first
                return
            }
        }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .darkText
        _ = scenes.map { scene in
            let action = UIAlertAction(title: scene.iotSceneName, style: .default) { [weak self] action in
                guard let weakSelf = self else { return }
                //TODO: 切换场景
                weakSelf.sceneVM.sceneModel = scene
            }
            alertVC.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemBlue, forKey: "_titleTextColor")
        
        alertVC.addAction(cancel)
        self.present(alertVC, animated: false)
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
    
    deinit {
        print("---设备绑定页面：被释放-----")
    }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: style.rawValue, for: indexPath)
            //MARK: MVVM 双向绑定逻辑
            switch style {
            case .SN:
                let snCell = cell as! JHDeviceSNCell
                snCell.bind(viewModel: snVM)
                self.snVM.bind(view:snCell)
            case .Scence:
                let scene = cell as! JHDeviceSceneCell
                scene.bind(viewModel: self.sceneVM)
                self.sceneVM.bind(view: scene)
            case .Nick:
                let nick = cell as! JHDeviceNickCell
                nick.bind(viewModel: self.nickVM)
                self.nickVM.bind(view: nick)
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
                loadSceneData()
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
        
        guard let sn = snVM.SNCode,sn.count > 0 else {
            VCTools.toast("请输入设备SN号")
            return
        }
        
        if scenes != nil && scenes.sn == snVM.SNCode {
            showSenceAlert(scenes.content)
            return
        }
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/IOTDeviceScene/GetIOTDeviceSceneList")
        let requestDic = ["StoreId":storeId, "SN": snVM.SNCode]
        let hud = MBProgressHUD.showAdded(to: (UIViewController.topVC?.view)!, animated: true)
        hud.removeFromSuperViewOnHide = true
        AF.request(urlStr,
                   method: .post,
                   parameters: requestDic as Parameters,
                   encoding: JSONEncoding.default)
            .response {[weak self] response in
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
                OperationQueue.main.addOperation {
                    weakSelf.showSenceAlert(weakSelf.scenes.content)
                }
            }else{
                let msg = json["Message"].stringValue
                OperationQueue.main.addOperation {
                    VCTools.toast(msg)
                }
            }
        }
    }
    func submit() {
        var apithmod = "SaveIntelligentDeviceInfo"
        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
        let data = try! jsonEncoder.encode(bindModel)
        var param:[String:Any] = JSON(data).dictionaryObject!
        if isPersonal {
            apithmod = "SavePersonDeviceInfo"
            param.removeValue(forKey: "StoreId")
        }
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/IntelligentDeviceSetting/\(apithmod)")
        let hud = MBProgressHUD.showAdded(to: (UIViewController.topVC?.view)!, animated: true)
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
            let result = json["IsSuccess"].boolValue
            if result {
                //网页刷新
                NotificationCenter.default.post(name: .init(rawValue: "refreshShowBindingIntelDescision"), object: nil, userInfo: nil)
            }else{
                let msg = json["Message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}
