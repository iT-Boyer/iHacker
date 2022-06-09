//
//  PhotoHomeController.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import UIKit
import JHBase

class PhotoHomeController: JHPhotoBaseController {
    
    var storeId = ""
    var pageIndex = 1
    var totalCount = 0
    var dataArray:[PhotoBaseVM] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    func createView() {
//        navTitle = "图片集"
        //Bar
        navBar.addSubviews([titleControl,rightView])
        titleControl.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
        }
        
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
        tb.register(PhotoBaseCell.self, forCellReuseIdentifier: "PhotoBaseCell")
        tb.register(PhotoCollectCell.self, forCellReuseIdentifier: "PhotoCollectCell")
        typeControl.frame.size.height = 40
        tb.tableHeaderView = typeControl
        return tb
    }()
    
    lazy var titleControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["图片", "视频"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = .k2CD773
        segment.backgroundColor = .white
        segment.layer.borderColor = UIColor.k2CD773.cgColor
        segment.layer.borderWidth = 0.5
        let normal:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2CD773]
        let selected:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.white]
        segment.setTitleTextAttributes(normal, for: .normal)
        segment.setTitleTextAttributes(selected, for: .selected)
        let normalColor = UIImage(color: .white, size: CGSize(width: 1.0, height: 1.0))
        let selectedColor = UIImage(color: .k2CD773, size: CGSize(width: 1.0, height: 1.0))
        segment.setBackgroundImage(normalColor, for: .normal, barMetrics: .default)
        segment.setBackgroundImage(selectedColor, for: .selected, barMetrics: .default)
        segment.setBackgroundImage(selectedColor, for: .highlighted, barMetrics: .default)
        let clear = UIImage(color: .clear, size: CGSize(width: 0, height: 0))
        segment.setDividerImage(clear, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.addTarget(self, action: #selector(titleControlChange(_ :)), for: .valueChanged)
        return segment
    }()
    
    lazy var typeControl: JHSegmentedControl = {
        // 设置字体样式
        let normal:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2F3856,
                                                   .font:UIFont.systemFont(ofSize: 14)]
        let selected:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.k2CD773,
                                                     .font:UIFont.systemFont(ofSize: 16, weight: .bold)]
        
        let segment = JHSegmentedControl(items: ["获得荣誉", "环境图片"],normal: normal,selected:selected)
        //添加
        segment.addBottomline()
        segment.line.snp.updateConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width/2 - 40)
        }
        segment.addTarget(self, action: #selector(typeControlChange(_ :)), for: .valueChanged)
        return segment
    }()
    
    
    func titleControlChange(_ segmented: UISegmentedControl) {
        //TODO: 图片 视频 分类
    }
    func typeControlChange(_ segmented: JHSegmentedControl) {
        //TODO: 获得荣誉, 环境图片 分类
        segmented.animateLine()
    }
    lazy var rightView: UIView = {
        let right = UIView()
        let upbtn = UIButton()
        upbtn.setImage(.init(named:"upload"), for: .normal)
        upbtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 新增 0: 图片 1:视频
            
        }
        let setbtn = UIButton()
        setbtn.setImage(.init(named: "set"), for: .normal)
        setbtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            //TODO: 设置
            let setvc = JHPhotoSetController()
            wf.navigationController?.present(setvc, animated: true)
        }
        
        right.addSubviews([upbtn,setbtn])
        
        upbtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.left.centerY.equalToSuperview()
        }
        
        setbtn.snp.makeConstraints { make in
            make.size.equalTo(upbtn)
            make.left.equalTo(upbtn.snp.right).offset(10)
            make.right.centerY.equalToSuperview()
        }
        return right
    }()
}

extension PhotoHomeController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = dataArray[indexPath.row].number > 0 ? "PhotoCollectCell":"PhotoBaseCell"
        let cell:PhotoBaseCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PhotoBaseCell
        return cell
    }
}
