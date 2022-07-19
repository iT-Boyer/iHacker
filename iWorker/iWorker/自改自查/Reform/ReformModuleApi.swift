//
//  ReformModuleApi.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import Viperit

//MARK: - ReformRouter API
protocol ReformRouterApi: RouterProtocol {
}

//MARK: - ReformView API
/**
 视图
 1. 响应 展示器的事件
 */
protocol ReformViewApi: UserInterfaceProtocol {
    func showloading()
    func hideloading()
    func refreshUI(model:BaseModel)
}

//MARK: - ReformPresenter API
/**
 展示器：模块做了什么
 1. 显示检查项列表
 2. 更新检查项状态
 */
protocol ReformPresenterApi: PresenterProtocol {
    
    func receivedResponse(_ data: BaseModel)
    func receivedError(_ error: ServiceError)
}

//MARK: - ReformInteractor API
/**
 用例描述：
 展示列表，显示检查项状态，进入拍照页面
 其中逻辑层任务：
 1. 获取列表数据
 2. 更新检查项状态
 3. BaseAction
 */
protocol ReformInteractorApi: InteractorProtocol {
    func loadData()
}
