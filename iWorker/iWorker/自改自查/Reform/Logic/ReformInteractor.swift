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
    
    func loadData() {
        ReformService.shared.getComInspectOptionList {[weak self] result in
            guard let weakSelf = self else { return }
            if let error = result.error {
                weakSelf.presenter.receivedError(error)
            } else {
                if let reformTask:ReformCommonModel = ReformCommonModel.parsed(data: result.data!)
                {
                    weakSelf.presenter.receivedResponse(reformTask)
                }
            }
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension ReformInteractor {
    var presenter: ReformPresenterApi {
        return _presenter as! ReformPresenterApi
    }
}
