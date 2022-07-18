//
//  IndexView.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import UIKit
import Viperit

//MARK: IndexView Class
final class IndexView: TableUserInterface {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ViperIt"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.demos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let module = displayData.demos[indexPath.row]
        let text = module.rawValue
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = displayData.demos[indexPath.row]
        presenter.showDemo(demo: demo)
    }
}

//MARK: - IndexView API
extension IndexView: IndexViewApi {
    
    func refresh(demos: [AppModules]) {
        displayData.demos = demos
        tableView.reloadData()
    }
}

// MARK: - IndexView Viper Components API
private extension IndexView {
    var presenter: IndexPresenterApi {
        return _presenter as! IndexPresenterApi
    }
    var displayData: IndexDisplayData {
        return _displayData as! IndexDisplayData
    }
}
