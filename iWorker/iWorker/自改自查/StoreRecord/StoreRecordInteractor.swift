//
//  StoreRecordInteractor.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - StoreRecordInteractor Class
final class StoreRecordInteractor: Interactor {
}

// MARK: - StoreRecordInteractor API
extension StoreRecordInteractor: StoreRecordInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension StoreRecordInteractor {
    var presenter: StoreRecordPresenterApi {
        return _presenter as! StoreRecordPresenterApi
    }
}
