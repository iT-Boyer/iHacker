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
    
    private var _alertView: UIView!
    private var _alertTitle: UILabel!
    private var _alertMessage: UILabel!
    private var _alertActionStackView: UIStackView!
    var style: JHAlertControllerStyle
    
    init(title: String!, message: String!, image: UIImage!, style: JHAlertControllerStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        createView()
        _alertTitle.text = title;
        _alertMessage.text = message;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
    
    func createView() {
        
    }
}
