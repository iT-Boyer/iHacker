//
//  JHReformVC.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//

import Foundation
import Viperit
import UIKit
import SnapKit
import JHBase
import MBProgressHUD

// MARK: - ReformBaseNavVC

@objcMembers open class ReformBaseNavVC: UserInterface {
    
    @objc public var navTitle: String? {
        didSet {
            if let tmpTitle = navTitle, tmpTitle.isEmpty == false {
                navBar.titleLabel.text = tmpTitle
            }
        }
    }
    
    // MARK: - Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(title: String) {
        navTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kF5F5F5
        self.view.addSubview(navBar)
        navBar.frame = .init(x: 0, y: 0, width: kScreenWidth, height: kNaviBarMaxY)
        createView()
        loadData()
    }
    
    func createView() {}
    
    func loadData() {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc open func backBtnClicked(_ btn: UIButton) -> Void {
        guard let navi = self.navigationController else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        if navi.viewControllers.count == 1 {
            self.dismiss(animated: false, completion: nil)
        } else {
            navi.popViewController(animated: true)
        }
    }
    var hub:MBProgressHUD!
    func showloading(){
        hub = MBProgressHUD.showAdded(to:view, animated: true)
        hub.removeFromSuperViewOnHide = true
    }
    
    func hideloading() {
        hub.hide(animated: true)
    }
    
    @objc open func refreshBtnClicked(_ btn: UIButton) {}
    
    @objc open func refreshImgClicked(_ btn: UIButton) {}
    
    // MARK: - API
    @discardableResult
    public func showNoDataView(_ superView: UIView? = nil, imgName: String? = nil, tipMsg: String? = nil) -> Self {
        emptyView.refreshBtn.isHidden = true
        let imgPath: String = imgName ?? "nodata_green"
        let tipText: String = tipMsg ?? "暂无数据"
        return showEmptyView(in: superView, imgName: imgPath, tipMsg: tipText)
    }
    
    @discardableResult
    public func showNoInternet(_ superView: UIView? = nil, imgName: String? = nil, tipMsg: String? = nil) -> Self {
        emptyView.refreshBtn.isHidden = false
        let imgPath: String = imgName ?? "nodata_blue"
        let tipText: String = tipMsg ?? "暂无数据"
        return showEmptyView(in: superView, imgName: imgPath, tipMsg: tipText)
    }
    
    @discardableResult
    public func hideEmptyView() -> Self {
        emptyView.removeFromSuperview()
        return self
    }
    
    func showEmptyView(in superView: UIView?, imgName: String, tipMsg: String) -> Self {
        if imgName.contains(".bundle") == true {
            emptyView.imgBtn.setImage(UIImage(named: imgName), for: .normal)
        } else {
            let imgPath = "JHUniversalResource.bundle/\(imgName)"
            emptyView.imgBtn.setImage(UIImage(named: imgPath), for: .normal)
        }
        emptyView.titleLabel.text = tipMsg
        
        var tmpView: UIView = self.view
        if let superView = superView {
            tmpView = superView
        }
        if tmpView.subviews.contains(emptyView) {
            tmpView.bringSubviewToFront(emptyView)
        } else {
            tmpView.addSubview(emptyView)
        }
        emptyView.frame = tmpView.bounds
        // 不遮挡导航栏
        if tmpView.subviews.contains(navBar) {
            tmpView.bringSubviewToFront(navBar)
        }
        return self
    }
    
    // MARK: - Lazy Load
    
    lazy public var navBar: ReformBaseNavBar = {
        let tmpView = ReformBaseNavBar.init(frame: .zero)
        tmpView.backBtn.addTarget(self, action: #selector(backBtnClicked(_:)), for: .touchUpInside)
        return tmpView
    }()
    
    lazy public var emptyView: ReformBaseEmptyView = {
        let tmpView = ReformBaseEmptyView.init(frame: .zero)
        tmpView.refreshBtn.addTarget(self, action: #selector(refreshBtnClicked(_:)), for: .touchUpInside)
        tmpView.imgBtn.addTarget(self, action: #selector(refreshImgClicked(_:)), for: .touchUpInside)
        return tmpView
    }()
    
}

// MARK: - ReformBaseNavBar

@objcMembers public class ReformBaseNavBar: UIView {
    
    public var navTitle: String? {
        didSet {
            if let tmpTitle = navTitle, tmpTitle.isEmpty == false {
                titleLabel.text = tmpTitle
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .kFCFCFC
        self.addSubview(titleLabel)
        self.addSubview(backBtn)
        self.addSubview(lineView)
        
        setupFrame()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupFrame() -> Void {
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(60)
            make.top.equalTo(kStatusBarHeight)
            make.height.equalTo(kNaviBarHeight)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(kStatusBarHeight)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Lazy Load
    lazy public var titleLabel: UILabel = {
        let tmpLabel = UILabel.init(frame: .zero)
        tmpLabel.font = .kBoldFont18
        tmpLabel.textColor = .k333333
        tmpLabel.textAlignment = .center
        return tmpLabel
    }()
    
    lazy public var backBtn: UIButton = {
        let tmpBtn = UIButton.init(type: .custom)
        let imgPath = "JHUniversalResource.bundle/arrow_left_dark"
        tmpBtn.setImage(UIImage(named: imgPath), for: .normal)
        return tmpBtn
    }()
    
    lazy public var lineView: UIView = {
        let tmpView = UIView.init(frame: .zero)
        tmpView.backgroundColor = .kF7F7F7
        return tmpView
    }()
}

// MARK: - ReformBaseEmptyView

@objcMembers public class ReformBaseEmptyView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let container: UIView = UIView()
        self.addSubview(container)
        container.addSubview(imgBtn)
        container.addSubview(titleLabel)
        container.addSubview(refreshBtn)
        
        setupFrame(container: container)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupFrame(container: UIView) -> Void {
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imgBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().offset(5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(12)
        }
        
        refreshBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Lazy Load
    
    lazy public var titleLabel: UILabel = {
        let tmpLabel = UILabel.init(frame: .zero)
        tmpLabel.text = "暂无数据"
        tmpLabel.font = .kFont14
        tmpLabel.textAlignment = .center
        tmpLabel.textColor = .k999999
        tmpLabel.numberOfLines = 0
        return tmpLabel
    }()
    
    lazy public var imgBtn: UIButton = {
        let tmpView = UIButton(type: .custom)
        tmpView.adjustsImageWhenHighlighted = false
        return tmpView
    }()
    
    lazy public var refreshBtn: UIButton = {
        let tmpBtn = UIButton.init(type: .custom)
        tmpBtn.isHidden = true
        let normalPath = "JHUniversalResource.bundle/refresh_text_normal"
        let highlightPath = "JHUniversalResource.bundle/refresh_text_highlight"
        
        tmpBtn.setImage(UIImage(named: normalPath), for: .normal)
        tmpBtn.setImage(UIImage(named: highlightPath), for: .highlighted)
        return tmpBtn
    }()
}

