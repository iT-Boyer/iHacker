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
        if demo == .Check {
            let reform = ReformModules.Reform.build()
            reform.router.show(from: viewController, embedInNavController: false, setupData: nil)
        }else{
            let toVC = demo.build()
            toVC.router.show(from: viewController, embedInNavController: false, setupData: nil)
        }
    }
}

// MARK: - Index Viper Components
private extension IndexRouter {
    var presenter: IndexPresenterApi {
        return _presenter as! IndexPresenterApi
    }
}
