//
//  JHUnitOrgAlertController.swift
//  iWorker
//
//  Created by boyer on 2022/1/17.
//

import UIKit

enum JHAlertControllerStyle {
    case JHAlertControllerStyleAlert, JHAlertControllerStyleSheet, JHAlertControllerStyleToast
}

class JHUnitOrgAlertController: UIViewController {
    
    private var alertView: UIView!
    private var alertTitle: UILabel!
    private var alertMessage: UILabel!
    private var alertActionStackView: UIStackView!
    var style: JHAlertControllerStyle!
    var afterDelay = 0.0
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    // MARK: 交互提示框
    convenience init(title: String!, message: String!, image: UIImage!, style: JHAlertControllerStyle) {
        self.init()
        self.style = style
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        createView()
        alertTitle.text = title
        alertMessage.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //吐司提示框
    func showMessage(_ msg:String,after:TimeInterval,style:JHAlertControllerStyle) {
        createMsgView()
        self.style = style
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        alertMessage.text = msg
        afterDelay = after
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{
            super.modalPresentationStyle = newValue
        }
        get{
            .overCurrentContext
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.style == .JHAlertControllerStyleToast {
            self.alertView.layer.shadowColor   = UIColor(white: 0, alpha: 0.07).cgColor
            self.alertView.layer.shadowOffset  = CGSize.zero
            self.alertView.layer.shadowOpacity = 1
            self.alertView.layer.shadowRadius  = 8
            self.perform(#selector(dismiss(animated:completion:)), with:nil, afterDelay: afterDelay)
        }
    }
    func createView() {
        //
        self.view.backgroundColor = .init(white: 0, alpha: 0.6)
        alertView = UIView()
        alertView.layer.cornerRadius = 8.0
        alertView.backgroundColor = .white
        alertTitle = UILabel()
        alertMessage = UILabel()
        alertMessage.numberOfLines = 0
        alertMessage.textAlignment = .center
        alertMessage.font = .systemFont(ofSize: 16)
        alertMessage.textColor = .init(red: 39/255.0, green: 39/255.0, blue: 39/255.0,alpha: 1.0)
        alertActionStackView = UIStackView()
        view.addSubview(alertView)
        alertView.addSubview(alertTitle)
        alertView.addSubview(alertMessage)
        alertView.addSubview(alertActionStackView)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(48)
        }
        alertMessage.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
        }
        alertActionStackView.snp.makeConstraints { make in
            make.top.equalTo(alertMessage.snp.bottom).offset(24)
            make.left.equalTo(27)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-18)
            make.height.equalTo(38)
        }
    }
    func createMsgView() {
        view.backgroundColor = .clear
        alertView = JHShapeView(corners: [.bottomLeft, .bottomRight, .topRight], radii: .init(width: 14, height: 14),fillColor: .white)
        alertMessage = UILabel()
        alertMessage.numberOfLines = 0
        alertMessage.textAlignment = .center
        alertMessage.font = .systemFont(ofSize: 16)
        alertMessage.textColor = .init(red: 39/255.0, green: 39/255.0, blue: 39/255.0,alpha: 1.0)
        view.addSubview(alertView)
        alertView.addSubview(alertMessage)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(48)
        }
        alertMessage.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.center.equalToSuperview()
            make.left.equalTo(20)
        }
    }
    
    func addAction(action:JHAlertAction) {
        alertActionStackView.addArrangedSubview(action)
        alertActionStackView.distribution = .fillEqually
        
        if alertActionStackView.arrangedSubviews.count > 2 {
            alertActionStackView.axis = .vertical
        }else{
            alertActionStackView.axis = .horizontal
            alertActionStackView.spacing = 20
        }
        action.addTarget(self, action: #selector(dissmiss(action:)), for: .touchDown)
    }
    @objc
    func dissmiss(action:JHAlertAction) {
        self.dismiss(animated: true, completion: nil)
    }
}

enum JHAlertActionStyle {
    case JHAlertActionStyleDefault,
         JHAlertActionStyleCancle,
         JHAlertActionStyleConfirm
}
class JHAlertAction: UIButton {
    
    var action:()->()
    init(_ title:String,style:JHAlertActionStyle,action:@escaping ()->() = {}) {
        self.action = action
        super.init(frame: CGRect.zero)
        self.addTarget(self, action: #selector(tapped(action:)), for: .touchDown)
        self.setTitle(title, for: .normal)
        switch style {
        case .JHAlertActionStyleDefault:
            self.setTitleColor(.black, for: .normal)
        case .JHAlertActionStyleCancle:
            self.setTitleColor(.red, for: .normal)
        case .JHAlertActionStyleConfirm:
            self.setTitleColor(.blue, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc
    func tapped(action:JHAlertAction) {
        self.action()
    }
}
