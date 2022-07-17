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
    
    func showCamera() {
        let camera = AppModules.Camera.build()
        let router = camera.router as! CameraRouter
//        router.present(from: viewController, embedInNavController: true)
//        router.present(from: viewController, embedInNavController: false)
        camera.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
}

// MARK: - Index Viper Components
private extension IndexRouter {
    var presenter: IndexPresenterApi {
        return _presenter as! IndexPresenterApi
    }
}
