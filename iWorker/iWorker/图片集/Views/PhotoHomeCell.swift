//
//  PhotoHomeCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/9.
//

import Foundation
import UIKit

class PhotoHomeCell: PhotoBaseCell {
    
    var model:StoreAmbientModel?{
        didSet{
            guard let mm = model else { return }
            titleLab.text = mm.ambientDesc
            iconView.kf.setImage(with: URL(string: mm.ambientURL), placeholder: UIImage(named:"videoplaceholdersmall"))
        }
    }
}
