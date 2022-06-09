//
//  PhotoBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import UIKit

class PhotoBaseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        
    }
    
    
}
