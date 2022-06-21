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
    var needRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: .init(rawValue: "JHPhotoBase_refreshList"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needRefresh {
            pageIndex = 1
            loadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func refreshList() {
        needRefresh = true
    }
}

extension JHPhotoBaseController:UITableViewDataSource,UITableViewDelegate
{
    func loadData() {needRefresh = false}
    func numberOfRowsInSection() -> Int {0}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
