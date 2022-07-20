//
//  MyRecordInteractor.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - MyRecordInteractor Class
final class MyRecordInteractor: Interactor {
}

// MARK: - MyRecordInteractor API
extension MyRecordInteractor: MyRecordInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MyRecordInteractor {
    var presenter: MyRecordPresenterApi {
        return _presenter as! MyRecordPresenterApi
    }
}
