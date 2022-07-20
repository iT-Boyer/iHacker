//
//  ReformRouter.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import Foundation
import Viperit

// MARK: - ReformRouter class
final class ReformRouter: Router {
}

// MARK: - ReformRouter API
extension ReformRouter: ReformRouterApi {
    
    func goMyRecord() {
        let my = ReformModules.MyRecord.build()
        my.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
    
    func goStoreRecord() {
        let store = ReformModules.StoreRecord.build()
        store.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
    
    func goSetting() {
        let my = ReformModules.Setting.build()
        my.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
    
}

// MARK: - Reform Viper Components
private extension ReformRouter {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
}
