//
//  IndexModuleApi.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import Viperit

//MARK: - IndexRouter API
//跳转逻辑：VC ，导航，转场
// 以go动词开始比较容易立即
protocol IndexRouterApi: RouterProtocol {
    func showCamera()
    func gotoXX()
}

//MARK: - IndexView API
//UIAction 抽象功能
protocol IndexViewApi: UserInterfaceProtocol {

}

//MARK: - IndexPresenter API
//UI交互：增删改查，同时支持VC的相关生命周期
// 定义了模块可以做什么
// 赋值用例接口对象：在VC中通过用例接口对象（及展示器）来实现UI跳转逻辑
protocol IndexPresenterApi: PresenterProtocol {
    func showCamera()
    func loadData()
    func changeXX()
}

//MARK: - IndexInteractor API
//实体数据逻辑：API请求，数据库查询
protocol IndexInteractorApi: InteractorProtocol {
    func reqServer()
}
