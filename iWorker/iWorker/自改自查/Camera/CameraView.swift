//
//  CameraView.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import UIKit
import Viperit

//MARK: CameraView Class
final class CameraView: UserInterface {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "拍照"
        view.backgroundColor = .white
    }
    
}

//MARK: - CameraView API
extension CameraView: CameraViewApi {
}

// MARK: - CameraView Viper Components API
private extension CameraView {
    var presenter: CameraPresenterApi {
        return _presenter as! CameraPresenterApi
    }
    var displayData: CameraDisplayData {
        return _displayData as! CameraDisplayData
    }
}
