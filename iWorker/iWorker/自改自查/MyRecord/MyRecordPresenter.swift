//
//  MyRecordPresenter.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - MyRecordPresenter Class
final class MyRecordPresenter: Presenter {
}

// MARK: - MyRecordPresenter API
extension MyRecordPresenter: MyRecordPresenterApi {
}

// MARK: - MyRecord Viper Components
private extension MyRecordPresenter {
    var view: MyRecordViewApi {
        return _view as! MyRecordViewApi
    }
    var interactor: MyRecordInteractorApi {
        return _interactor as! MyRecordInteractorApi
    }
    var router: MyRecordRouterApi {
        return _router as! MyRecordRouterApi
    }
}
