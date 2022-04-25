//
//  JHVideoActBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/4/25.
//

import UIKit
import SnapKit
import JHBase
class JHPersonVideoActCell: JHVideoActBaseCell {
    
}

class JHSquareVideoActCell: JHVideoActBaseCell {
    
    override func customLab() -> UILabel {
        let lab = super.customLab()
        lab.textColor = .white
        lab.backgroundColor = .initWithHex("FF3359")
        lab.layer.cornerRadius = 2
        return lab
    }
}

class JHVideoActBaseCell: UITableViewCell {

    lazy var rootView: UIView = {
        let root = UIView()
        root.backgroundColor = .white
        root.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }
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
    
    func createView() {
        //
        self.contentView.addSubview(rootView)
        rootView.addSubviews([imgView, titleLab, numLab, ingLab, dateLab])
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
        }
        ingLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.height.equalTo(15)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.bottom.equalTo(-10)
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
