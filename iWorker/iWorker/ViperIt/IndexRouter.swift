//
//  IndexRouter.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - IndexRouter class
final class IndexRouter: Router {
}

// MARK: - IndexRouter API
extension IndexRouter: IndexRouterApi {
    func showDemo(demo: AppModules) {
        let vc = demo.build()
        vc.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
}

// MARK: - Index Viper Components
private extension IndexRouter {
    var presenter: IndexPresenterApi {
        return _presenter as! IndexPresenterApi
    }
}
