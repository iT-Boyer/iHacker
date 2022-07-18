//
//  ReformPresenter.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import Foundation
import Viperit

// MARK: - ReformPresenter Class
final class ReformPresenter: Presenter {
}

// MARK: - ReformPresenter API
extension ReformPresenter: ReformPresenterApi {
}

// MARK: - Reform Viper Components
private extension ReformPresenter {
    var view: ReformViewApi {
        return _view as! ReformViewApi
    }
    var interactor: ReformInteractorApi {
        return _interactor as! ReformInteractorApi
    }
    var router: ReformRouterApi {
        return _router as! ReformRouterApi
    }
}
