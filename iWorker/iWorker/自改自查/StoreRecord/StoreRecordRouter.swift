//
//  StoreRecordRouter.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - StoreRecordRouter class
final class StoreRecordRouter: Router {
}

// MARK: - StoreRecordRouter API
extension StoreRecordRouter: StoreRecordRouterApi {
}

// MARK: - StoreRecord Viper Components
private extension StoreRecordRouter {
    var presenter: StoreRecordPresenterApi {
        return _presenter as! StoreRecordPresenterApi
    }
}
