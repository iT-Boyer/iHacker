//
//  ReformView.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import UIKit
import Viperit

//MARK: ReformView Class
final class ReformView: ReformBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navTitle = "自改自查"
    }
}

//MARK: - ReformView API
extension ReformView: ReformViewApi {
}

// MARK: - ReformView Viper Components API
private extension ReformView {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
    var displayData: ReformDisplayData {
        return _displayData as! ReformDisplayData
    }
}
