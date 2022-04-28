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
        navTitle = "活动广场"
        // Do any additional setup after loading the view.
        loadData(api: "ActivitySquare")
    }
    
    override func createView() {
        super.createView()
        self.tableView.register(JHSquareVideoActCell.self, forCellReuseIdentifier: "JHSquareVideoActCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHSquareVideoActCell = tableView.dequeueReusableCell(withIdentifier: "JHSquareVideoActCell") as! JHSquareVideoActCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
}
