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
}
