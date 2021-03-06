//
//  JHUnitOrgBaseViewController.swift
//  iWorker
//
//  Created by boyer on 2022/1/7.
//

import UIKit
import JHBase
import ESPullToRefresh

class JHUnitOrgBaseViewController: JHBaseNavVC{

    var storeId:String!
    var isAddChild:Bool!
    var dataArray:[JHUnitOrgBaseModel]! = []
    var pageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        installOHHTTPStubs()
    }
    //
    func loadData(_ isRefresh:Bool = false) {
        if isRefresh {
            self.pageIndex = 1
        }
    }
    
    func createView(){
        //列表
        self.view.addSubview(tableView)
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            /// 在这里做刷新相关事件
            loadData(true)
//            /// 如果你的刷新事件成功，设置completion自动重置footer的状态
//            self.tableView.es.stopPullToRefresh()
//            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
        }
        
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            /// 在这里做加载更多相关事件
            loadData()
//            /// 如果你的加载更多事件成功，调用es_stopLoadingMore()重置footer状态
//            self.tableView.es.stopLoadingMore()
//            /// 通过es_noticeNoMoreData()设置footer暂无数据状态
//            self.tableView.es.noticeNoMoreData()
        }
    }
    
    //MARK: getter
    lazy var tableView = { () -> UITableView in 
        let tbl = UITableView(frame: .zero, style: .grouped)
        tbl.delegate = self
        tbl.dataSource = self
        tbl.showsVerticalScrollIndicator = false
        tbl.showsHorizontalScrollIndicator = false
        tbl.backgroundColor = .init(hexString: "F5F5F5")
        tbl.estimatedRowHeight = 60
        tbl.rowHeight = UITableView.automaticDimension
        tbl.tableFooterView = UIView()
        tbl.separatorStyle = .none
        return tbl
    }()
}

extension JHUnitOrgBaseViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        12
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        print("点击事件")
    }
}
