//
//  AccountSecurityViewController.swift
//  iWorker
//
//  Created by boyer on 2022/5/11.
//

import UIKit
import JHBase

class AccountSecurityViewController: JHBaseNavVC {

    var dataArray: [String] {
        ["手机账号","设置密码","找回交易密码","手机账号Combine","设置密码Combine"]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navTitle = "账号安全"
        createView()
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
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tb
    }()
}

extension AccountSecurityViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let bind = PhoneAccountBindViewController()
            self.navigationController?.pushViewController(bind, animated: true)
        }
        if indexPath.row == 1 {
            let password = JHNewLoginSetPswViewController()
            self.navigationController?.pushViewController(password, animated: true)
        }
        if indexPath.row == 2 {
            let find = LoginGetBackPassword()
            self.navigationController?.pushViewController(find, animated: true)
        }
        if indexPath.row == 3 {
            let bindcombine = PhoneBindCombine()
            self.navigationController?.pushViewController(bindcombine, animated: true)
        }
    }
}
