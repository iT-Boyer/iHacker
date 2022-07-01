//
//  CheckReportViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit

class CheckReportViewController: CheckSelfThirdViewController {

    var reportId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect报告bar")
        bottomBtn.setTitle("保存", for: .normal)
        
    }
    
    override func nextStepAction() {
        //TODO: 保存
    }
    
    override var headerView: JHOptionsHeaderView{
        set{}
        get{
            JHOptionsHeaderView(name: "未通过检查项", note: "负责人")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
    }
}
