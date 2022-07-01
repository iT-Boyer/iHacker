//
//  InsSignViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase

class InsSignViewController: JHBaseNavVC {

    var signHandler:(String)->Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView() {
        navTitle = "签字"
        
    }
}
