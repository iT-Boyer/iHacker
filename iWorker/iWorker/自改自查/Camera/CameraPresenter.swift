//
//  CameraPresenter.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - CameraPresenter Class
final class CameraPresenter: Presenter {
}

// MARK: - CameraPresenter API
extension CameraPresenter: CameraPresenterApi {
}

// MARK: - Camera Viper Components
private extension CameraPresenter {
    var view: CameraViewApi {
        return _view as! CameraViewApi
    }
    var interactor: CameraInteractorApi {
        return _interactor as! CameraInteractorApi
    }
    var router: CameraRouterApi {
        return _router as! CameraRouterApi
    }
}
