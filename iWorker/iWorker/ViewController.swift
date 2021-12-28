//
//  ViewController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let tetlab = UILabel()
        tetlab.text = "第一步"
        tetlab.textAlignment = .center
        tetlab.textColor = UIColor.red
        self.view.addSubview(tetlab)
        tetlab.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.center.equalTo(self.view)
        }
    }
}

