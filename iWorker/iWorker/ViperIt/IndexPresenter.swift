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
    
    override func viewIsAboutToAppear() {
        loadData()
    }
    
}

// MARK: - IndexPresenter API
extension IndexPresenter: IndexPresenterApi {
    
    func showDemo(demo: AppModules) {
        router.showDemo(demo: demo)
    }
    
    func loadData() {
        let demos = interactor.reqServer()
        view.refresh(demos: demos)
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
