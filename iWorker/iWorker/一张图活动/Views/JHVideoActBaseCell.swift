//
//  JHVideoActBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/4/25.
//

import UIKit
import SnapKit
import JHBase
import Kingfisher
import SwifterSwift

class JHPersonVideoActCell: JHVideoActBaseCell {
    
}

class JHSquareVideoActCell: JHVideoActBaseCell {
    
    override func customLab() -> UILabel {
        let lab = super.customLab()
        lab.textColor = .white
        lab.backgroundColor = .initWithHex("FF3359")
        lab.layer.cornerRadius = 2
        lab.layer.masksToBounds = true
        lab.font = .systemFont(ofSize: 12)
        lab.textAlignment = .right
        return lab
    }
}

class JHVideoActBaseCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customLab()->UILabel {
        return UILabel()
    }
    
    var model:JHActivityModel!{
        didSet{
            titleLab.text = model.activityName
            numLab.text = "\(model.joinUserCount) 人参赛"
            dateLab.text = "活动时间：" + model.activityStartDate + "-" + model.activityEndDate
            if let url = URL(string: model.activityImagePath) {
                imgView.kf.indicatorType = .activity
                imgView.kf.setImage(with: url, placeholder: UIImage(named: "Kingfisher"))
            }
            
            ingLab.isHidden = true
            switch model.status {
            case .Apply:
                statusLab.text = " 审核中 "
                statusLab.textColor = .initWithHex("FF4934")
                break
            case .Wait:
                //未开始
                ingLab.isHidden = false
                ingLab.text = " 未开始 "
                lab(lab: ingLab, col: .initWithHex("FF3359"))
                statusLab.text = "审核通过"
                statusLab.textColor = .initWithHex("18D96F")
                break
            case .Ing:
                //火热进行中
                ingLab.isHidden = false
                ingLab.text = " 火热进行中 "
                lab(lab: ingLab, col: .initWithHex("FF3359"))
                statusLab.text = "审核通过"
                statusLab.textColor = .initWithHex("18D96F")
                break
            case .Over:
                //已结束
                ingLab.isHidden = false
                ingLab.text = " 已结束 "
                lab(lab: ingLab, col: .initWithHex("5E637B"))
                break
            case .Fail:
                statusLab.text = "审核未通过"
                statusLab.textColor = .initWithHex("FF4934")
                break
            default:
                //
                statusLab.text = " 未知 "
                statusLab.textColor = .white
                break
            }
            
        }
    }
    
    func lab(lab:UILabel, col:UIColor) {
        lab.textColor = col
        lab.layer.cornerRadius = 2
        lab.layer.borderColor = col.cgColor
        lab.layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 阴影颜色
        rootView.layer.shadowColor = UIColor.initWithHex("1B1C25").cgColor
        // 阴影偏移，默认(0, -3)
        rootView.layer.shadowOffset = CGSize.zero
        // 阴影透明度，默认0
        rootView.layer.shadowOpacity = 1
        // 阴影半径，默认3
        rootView.layer.shadowRadius = 4
        rootView.layer.cornerRadius = 6
        
        imgView.roundCorners( [.topLeft, .topRight], radius: 6)
    }
    lazy var rootView: UIView = {
        let root = UIView()
        root.backgroundColor = .white
        return root
    }()
    
    lazy var imgView:UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        return imgV
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .initWithHex("2F3856")
        lab.font = .systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .initWithHex("99A0B6")
        return lab
    }()
    
    lazy var ingLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 10)
        return lab
    }()
    lazy var dateLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .initWithHex("5E637B")
        return lab
    }()
    lazy var statusLab: UILabel = {
        return customLab()
    }()
    
    func createView() {
        //
        self.contentView.addSubview(rootView)
        rootView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }
        rootView.addSubviews([imgView, titleLab, numLab, ingLab, dateLab, statusLab])
        imgView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(138)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(imgView.snp.bottom).offset(8)
        }
        numLab.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.top.equalTo(imgView.snp.bottom).offset(8)
            make.left.greaterThanOrEqualTo(titleLab.snp.right).offset(8)
        }
        ingLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.height.equalTo(15)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
        }
        dateLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(ingLab.snp.bottom).offset(8)
            make.bottom.equalTo(-10)
        }
        statusLab.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.height.equalTo(22)
            make.left.greaterThanOrEqualTo(dateLab.snp.right).offset(5)
            make.centerY.equalTo(dateLab.snp.centerY)
        }
    }
    
}
