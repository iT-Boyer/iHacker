//
//  ReformInteractor.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import Foundation
import Viperit

// MARK: - ReformInteractor Class
final class ReformInteractor: Interactor {
}

// MARK: - ReformInteractor API
extension ReformInteractor: ReformInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ReformInteractor {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
}
