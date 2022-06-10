//
//  JHPhotoBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import UIKit
import JHBase

class JHPhotoBaseController: JHBaseNavVC {

    var storeId = ""
    var pageIndex = 1
    var totalCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        loadData()
    }
    func createView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = .white
        tb.removeTableFooterView()
        tb.separatorStyle = .none
        tb.estimatedRowHeight = 75
        tb.rowHeight = UITableView.automaticDimension
        tb.es.addPullToRefresh { [weak self] in
            guard let wf = self else{return}
            /// 在这里做刷新相关事件
            wf.pageIndex = 1
            wf.loadData()
        }
        
        /// 在这里做加载更多相关事件
        tb.es.addInfiniteScrolling { [weak self] in
            guard let wf = self else{return}
            wf.loadData()
        }
        return tb
    }()
    
}

extension JHPhotoBaseController:UITableViewDataSource,UITableViewDelegate
{
    func loadData() {}
    func numberOfRowsInSection() -> Int {0}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
