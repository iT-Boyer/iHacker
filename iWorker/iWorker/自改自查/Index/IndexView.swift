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
        navigationItem.title = "ViperIt"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "测试一"
        case 1:
            cell.textLabel?.text = "测试二"
        case 2:
            cell.textLabel?.text = "测试三"
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: presenter.showCamera()
        default: break
        }
    }
}

//MARK: - IndexView API
extension IndexView: IndexViewApi {
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
