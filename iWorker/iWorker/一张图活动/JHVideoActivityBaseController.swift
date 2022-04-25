//
//  JHVideoActivityBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/4/22.
//

import UIKit
import JHBase

class JHVideoActivityBaseController: JHBaseNavVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView(){
        //导航条右边按钮
        let complate = UIButton()
        complate.setImage(.init(named: "add"), for: .normal)
        complate.jh.setHandleClick { button in
            
        }
        
        navBar.addSubview(complate)
        complate.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        //列表
        self.view.addSubview(tableView)
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            /// 在这里做刷新相关事件
//            loadData(true)
//            /// 如果你的刷新事件成功，设置completion自动重置footer的状态
//            self.tableView.es.stopPullToRefresh()
//            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
        }
        
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            /// 在这里做加载更多相关事件
//            loadData()
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

extension JHVideoActivityBaseController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
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
