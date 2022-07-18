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
}

// MARK: - Reform Viper Components
private extension ReformRouter {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
}
