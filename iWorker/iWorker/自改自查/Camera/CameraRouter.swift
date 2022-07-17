//
//  CameraRouter.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - CameraRouter class
final class CameraRouter: Router {
}

// MARK: - CameraRouter API
extension CameraRouter: CameraRouterApi {
}

// MARK: - Camera Viper Components
private extension CameraRouter {
    var presenter: CameraPresenterApi {
        return _presenter as! CameraPresenterApi
    }
}
