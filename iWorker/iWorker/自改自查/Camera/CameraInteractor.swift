//
//  CameraInteractor.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - CameraInteractor Class
final class CameraInteractor: Interactor {
}

// MARK: - CameraInteractor API
extension CameraInteractor: CameraInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension CameraInteractor {
    var presenter: CameraPresenterApi {
        return _presenter as! CameraPresenterApi
    }
}
