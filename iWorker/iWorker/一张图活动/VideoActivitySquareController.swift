//
//  VideoActivitySquareController.swift
//  iWorker
//
//  Created by boyer on 2022/4/22.
//

import UIKit

class VideoActivitySquareController: JHVideoActivityBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        self.tableView.register(JHSquareVideoActCell.self, forCellReuseIdentifier: "JHSquareVideoActCell")
        
    }
    
}
