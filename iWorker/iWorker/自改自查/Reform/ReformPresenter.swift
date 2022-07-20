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
    
    override func viewHasLoaded() {
        view.showloading()
        interactor.loadData()
    }
}

// MARK: - ReformPresenter API
extension ReformPresenter: ReformPresenterApi {
    func showMyRecord() {
        router.goMyRecord()
    }
    
    func showStoreRecord() {
        router.goStoreRecord()
    }
    
    func showSetting() {
        router.goSetting()
    }
    
    
    func receivedResponse(_ data: BaseModel) {
        view.hideloading()
        view.refreshUI(model: data)
    }
    
    func receivedError(_ error: ServiceError) {
        view.hideloading()
    }
    
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
