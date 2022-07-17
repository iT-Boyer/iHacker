//
//  IndexModuleApi.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Viperit

//MARK: - IndexRouter API
protocol IndexRouterApi: RouterProtocol {
    func showCamera()
}

//MARK: - IndexView API
protocol IndexViewApi: UserInterfaceProtocol {

}

//MARK: - IndexPresenter API
protocol IndexPresenterApi: PresenterProtocol {
    func showCamera()
}

//MARK: - IndexInteractor API
protocol IndexInteractorApi: InteractorProtocol {
    
}
