//
//  IndexInteractor.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Foundation
import Viperit

// MARK: - IndexInteractor Class
final class IndexInteractor: Interactor {
}

// MARK: - IndexInteractor API
extension IndexInteractor: IndexInteractorApi {
    
    func reqServer()->[AppModules] {
        let demo = AppModules.allCases
        return demo
    }
}

// MARK: - Interactor Viper Components Api
private extension IndexInteractor {
    var presenter: IndexPresenterApi {
        return _presenter as! IndexPresenterApi
    }
}
