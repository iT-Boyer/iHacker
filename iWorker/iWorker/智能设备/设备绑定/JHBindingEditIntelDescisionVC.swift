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
enum PageActionType:Int {
    case none = 0    // 默认状态
    case scanbind   //绑定页面扫一扫：设备场景多个时，自动上屏
    case detail     //详情编辑设备
    case scanIndex   //首页扫一扫：跳转到绑定页面
    case autoSubmit   //自动提交：支持首页地图扫一扫自动提交功能
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
    
    var SN = ""
    var storeId = "00000000-0000-0000-0000-000000000000"
    
    var pageType:PageActionType = .none
    //详情属性//详情页面只能修改执行时间
    var isDetail:Bool{
        return pageType == .detail
    }
    var deviceId = ""
    
    // UI样式排序
    let infoRows:[DeviceCellStyle] = [.SN, .Scence, .Nick]
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
        model.userID = JHBaseInfo.userID
        model.appID = JHBaseInfo.appID
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
        sections = [infoRows,bindModel.workTimeList!]
        
        // UI
        createView()
        if isDetail {
            loadDevice()
        }else{
            //空白处隐藏键盘
            self.hideKeyboardWhenTappedAround()
            NotificationCenter.default.addObserver(forName: .init("JHDeviceScanSNCompleted"), object: nil, queue: .main) { [self] notfi in
                guard let code = notfi.userInfo?["SNCode"] else { return }
                scanBind(code as! String,type: .scanbind)
            }
        }
    }
    
    // MARK:- 按钮事件
    // MARK: 绑定设备
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
        
        submit()
    }
    
    //MARK: 支持：首页扫一扫，绑定页面扫一扫
    //Method cannot be marked @objc because the type of the parameter 2 cannot be represented in Objective-C
    //@objc func scanBind(_ sn:String, type:PageActionType)
    func scanBind(_ sn:String, type:PageActionType) {
        pageType = type
        SN = sn
        snVM.value = sn //扫描结果，更新UI上屏
        loadSceneData()
    }
    //绑定
    static func bindDevice(storeId:String) {
//        let vc = JHBindingEditIntelDescisionVC()
//        vc.navTitle = "绑定设备"
//        UIViewController.topVC?.present(vc, animated: true, completion: nil)
    }
    static func bindDevice2(storeId:String) {
//        let vc = JHBindingEditIntelDescisionVC()
//        vc.navTitle = "绑定设备"
//        UIViewController.topVC?.present(vc, animated: true, completion: nil)
    }
    //MARK: 场景展示的几种情况
    func scanBindhandler() {
        guard let list = scenes.content else { return }
        if pageType == .scanbind {
            pageType = .none
            // 绑定页面，直接上屏
            if list.count == 1 {
                sceneVM.sceneModel = list.first
            }
        }
        else
        if pageType == .scanIndex { // 从首页进入时
            if list.count == 1 {
                //MARK: 自动绑定
                pageType = .autoSubmit
                //初始化数据
                sceneVM.sceneModel = list.first
                //提交
                commitAction()
            }else{
                //MARK: 多个场景时，从首页进入绑定页面
                modalPresentationStyle = .fullScreen
                UIViewController.topVC?.present(self, animated: true, completion: {
                    //初始化数据，上屏
                    self.pageType = .none
                    self.snVM.value = self.SN
                })
            }
        }
        else
        {
            showSenceAlert()
        }
    }
    
    //MARK: 点击切换场景
    @objc func showSenceAlert() {
        
        guard let sn = snVM.SNCode,sn.count > 0 else {
            VCTools.toast("请输入设备SN号")
            return
        }
        
        if scenes == nil || scenes.sn != snVM.SNCode {
            loadSceneData()
            return
        }
        
        guard let list = scenes.content else { return }
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .darkText
        _ = list.map { scene in
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
        
        let bottomBtn = UIButton()
        if isDetail {
            bottomBtn.setTitle("删除", for: .normal)
            bottomBtn.backgroundColor = .initWithHex("fe2c2c", alpha: 0.3)
            bottomBtn.titleLabel?.font = .systemFont(ofSize: 17)
            bottomBtn.setTitleColor(.initWithHex("fe2c2c"), for: .normal)
            bottomBtn.layer.cornerRadius = 5
            bottomBtn.layer.borderColor = UIColor.initWithHex("fe2c2c").cgColor
            bottomBtn.layer.borderWidth = 1
            bottomBtn.jh.setHandleClick { button in
                let alert = UIAlertController(title: nil, message: "您确定要删除吗?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "取消", style: .default)
                let insure = UIAlertAction(title: "确定", style: .default) { action in
                    self.deleteAction()
                }
                alert.addAction(cancel)
                alert.addAction(insure)
                self.present(alert, animated: true)
            }
            //导航条完成按钮
            let complate = UIButton()
            complate.setTitle("完成", for: .normal)
            complate.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            complate.setTitleColor(.initWithHex("333333"), for: .normal)
            complate.jh.setHandleClick { button in
                
                self.submit()
            }
            
            navBar.addSubview(complate)
            complate.snp.makeConstraints { make in
                make.centerY.equalTo(navBar.titleLabel.snp.centerY)
                make.right.equalTo(-14)
                make.size.equalTo(CGSize.init(width: 50, height: 30))
            }
        }else{
            bottomBtn.setTitle("保存", for: .normal)
            bottomBtn.backgroundColor = .initWithHex("599199")
            bottomBtn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            bottomBtn.setTitleColor(.white, for: .normal)
            bottomBtn.layer.cornerRadius = 5
            bottomBtn.addTarget(self, action: #selector(commitAction), for: .touchDown)
        }
        
        
        view.addSubview(self.tableView)
        view.addSubview(bottomBtn)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        bottomBtn.snp.makeConstraints { make in
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
        addBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        addBtn.imageView?.contentMode = .scaleAspectFit
        addBtn.contentHorizontalAlignment = .right
        addBtn.jh.setHandleClick { button in
            if self.bindModel.workTimeList!.count == 10 {
                VCTools.toast("最多添加10条工作时间记录")
            }else{
                let picker = JHDeviceTimePicker()
                picker.timeHandler = { start,end in
                    let time = WorkTime(endTime: end, startTime: start)
                    //TODO: 时间选择器
                    self.bindModel.workTimeList!.append(time)
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
            make.size.equalTo(CGSize(width: 80, height: 34))
            make.centerY.equalToSuperview()
        }
        return headView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        return bindModel.workTimeList!.count
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
            cell.isUserInteractionEnabled = !isDetail
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
            let time = bindModel.workTimeList![indexPath.row]
            cell.startTime = time.startTime
            cell.endTime = time.endTime
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { //设备模块
            let style = infoRows[indexPath.row]
            if style == .Scence { showSenceAlert() }
        }
    }
    
    // MARK: 侧滑删除逻辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { action, sourceView, completionHandler in
            self.bindModel.workTimeList!.remove(at: indexPath.row)
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
                    weakSelf.scanBindhandler()
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
                NotificationCenter.default.post(name: .init("refreshShowBindingIntelDescision"), object: nil)
                if weakSelf.pageType == .autoSubmit {
                    NotificationCenter.default.post(name: .init("toDeviceH5ListVCKey"), object: nil)
                }
                else
                if weakSelf.pageType == .scanIndex{
                    OperationQueue.main.addOperation {
                        weakSelf.dismiss(animated: true) {
                            NotificationCenter.default.post(name: .init("toDeviceH5ListVCKey"), object: nil)
                        }
                    }
                }else{
                    weakSelf.backBtnClicked(UIButton())
                }
                
            }else{
                let msg = json["Message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

extension JHBindingEditIntelDescisionVC
{
    func loadDevice() {
        var param:[String:Any] = ["DeviceId":deviceId, "storeId":storeId, "UserId":JHBaseInfo.userID, "AppId":JHBaseInfo.appID]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/IntelligentDeviceSetting/GetSingleIntelligentDeviceInfoNew")
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
            let result = json["IsSuccess"].boolValue
            if result {
                let content = try! json["Content"].rawData()
                weakSelf.bindModel = JHDeviceBindModel.parsed(data: content)
                OperationQueue.main.addOperation {
                    weakSelf.snVM.value = weakSelf.bindModel.sn
                    weakSelf.sceneVM.sceneName = weakSelf.bindModel.deviceTypeName
                    weakSelf.nickVM.value = weakSelf.bindModel.name ?? ""
                    weakSelf.tableView.reloadData()
                }
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    @objc func deleteAction() {
        
        
        
        var apithmod = "DeleteIntelligentDevice"
        if isPersonal {
            apithmod = "DeletePersonDevice"
        }
        var param:[String:Any] = ["Id":bindModel.deviceID, "UserId":JHBaseInfo.userID, "AppId":JHBaseInfo.appID]
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
                OperationQueue.main.addOperation {
                    //网页刷新
                    NotificationCenter.default.post(name: .init(rawValue: "refreshShowBindingIntelDescision"), object: nil, userInfo: nil)
                    if weakSelf.isPersonal {
                        weakSelf.dismiss(animated: true)
                    }else{
                        weakSelf.backBtnClicked(UIButton())
                    }
                }
            }else{
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: nil, message: "删除失败，请联系客服处理", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "取消", style: .default)
                    let insure = UIAlertAction(title: "联系客服", style: .default) { action in
                        // 联系客服
                        UIApplication.shared.open(.init(string: "telprompt://\(400-9030-401)")!)
                    }
                    alert.addAction(cancel)
                    alert.addAction(insure)
                    weakSelf.present(alert, animated: true)
                }
            }
        }
    }
}
