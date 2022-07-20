//
//  StoreRecordPresenter.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - StoreRecordPresenter Class
final class StoreRecordPresenter: Presenter {
}

// MARK: - StoreRecordPresenter API
extension StoreRecordPresenter: StoreRecordPresenterApi {
}

// MARK: - StoreRecord Viper Components
private extension StoreRecordPresenter {
    var view: StoreRecordViewApi {
        return _view as! StoreRecordViewApi
    }
    var interactor: StoreRecordInteractorApi {
        return _interactor as! StoreRecordInteractorApi
    }
    var router: StoreRecordRouterApi {
        return _router as! StoreRecordRouterApi
    }
}
