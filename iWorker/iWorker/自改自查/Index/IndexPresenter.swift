//
//  IndexPresenter.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - IndexPresenter Class
final class IndexPresenter: Presenter {
}

// MARK: - IndexPresenter API
extension IndexPresenter: IndexPresenterApi {
    
    func showCamera() {
        router.showCamera()
    }
}

// MARK: - Index Viper Components
private extension IndexPresenter {
    var view: IndexViewApi {
        return _view as! IndexViewApi
    }
    var interactor: IndexInteractorApi {
        return _interactor as! IndexInteractorApi
    }
    var router: IndexRouterApi {
        return _router as! IndexRouterApi
    }
}
