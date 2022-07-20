//
//  MyRecordRouter.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import Foundation
import Viperit

// MARK: - MyRecordRouter class
final class MyRecordRouter: Router {
}

// MARK: - MyRecordRouter API
extension MyRecordRouter: MyRecordRouterApi {
}

// MARK: - MyRecord Viper Components
private extension MyRecordRouter {
    var presenter: MyRecordPresenterApi {
        return _presenter as! MyRecordPresenterApi
    }
}
