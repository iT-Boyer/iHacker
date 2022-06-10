//
//  JHPhotoAddController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit

class JHPhotoAddController: JHPhotoBaseController {

    /// 0:图片 1:图集
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func createView() {
        super.createView()
        navTitle = "添加图片"
    }

}
